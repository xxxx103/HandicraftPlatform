import base64
import json
import random
import uuid
from datetime import timedelta

from flask import Blueprint, views, render_template, request, jsonify, redirect, url_for, session
from flask_mail import Message
from werkzeug.security import generate_password_hash, check_password_hash

from config import QINIU_URL, NEW_QINIU_DOMAIN
from mail import send_mail
from pojo import *
from redis_cache import redis_cache
from extend import *
from utils import convert_qiniu_url

user_dp = Blueprint("user", __name__, url_prefix='/user', template_folder="../templates/user")


class loginUrl(views.MethodView):

    def get(self):
        return render_template('loginUI.html')

    def post(self):
        code = request.form.get("code")
        image = session.get("image")
        print("验证码对比：", code, image)
        if str(code).lower() == str(image).lower():
            email = request.form.get("email")
            password = request.form.get("password")
            print("登录信息：", email, password)
            user = User.query.filter(User.email == email, User.is_ok == 1).first()
            print("查询到的用户：", user)

            if user is not None:
                print("数据库中的密码：", user.password)
                print("用户输入的密码：", password)
                
                # 首先尝试直接比较（处理前端发送哈希值的情况）
                if user.password == password:
                    session["uid"] = user.id
                    return jsonify({"status": "200"})
                
                # 如果直接比较失败，尝试哈希比较
                is_valid = check_password_hash(user.password, password)
                print("密码验证结果：", is_valid)
                
                if is_valid:
                    session["uid"] = user.id
                    return jsonify({"status": "200"})
            return jsonify({"status": "500", "msg": "用户名或密码不正确", "error_pos": "#email_msg"})
        else:
            return jsonify({"status": "500", "msg": "验证码错误", "error_pos": "#code_msg"})


user_dp.add_url_rule('/login', endpoint='login', view_func=loginUrl.as_view('login'))


class registerUrl(views.MethodView):

    def get(self):
        return render_template('registerUI.html')

    def post(self):
        code = request.form.get("code")
        email = request.form.get("email")
        random_sample_old = redis_cache.get(email).decode()
        if random_sample_old.lower() == code.lower():
            username = request.form.get("username")
            password = request.form.get("password")
            email = request.form.get("email")
            name = request.form.get("name")
            phone = request.form.get("phone")
            addr = request.form.get("addr")
            id = str(uuid.uuid1()).replace('-', '')
            user = User(id=id, username=username, password=generate_password_hash(password), email=email, name=name,
                        phone=phone, addr=addr)
            db.session.add(user)
            db.session.commit()
            return redirect(url_for('user.login'))
        else:
            return render_template("registerUI.html", msg='动态码不正确')


user_dp.add_url_rule('/register', endpoint='register', view_func=registerUrl.as_view('register'))

@user_dp.route("/logout")
def logout():
    uid = session.get('uid')
    if uid is None:
        return redirect(url_for('index'))
    session.pop('uid')
    return redirect(url_for('index'))


@user_dp.route("/sendMail")
def sendMail():
    email = request.args.get("email")
    isEmail = User.query.filter(User.email == email, User.is_ok == 1).first()

    if not isEmail:
        random_sample = random.sample('1234567890abcdefghijklmnopqrstuvwxyz', 4)
        random_sample = ''.join(random_sample)
        redis_cache.set(email, str(random_sample))
        msg = Message(subject="创意手工艺品交易平台平台动态码", recipients=[email])
        msg.html = f"<b><img src='http://{NEW_QINIU_DOMAIN}/nyist.png' " \
                   "style='width:260px'></b><br><b>创意手工艺品交易平台注册动态码:" \
                   "<font color='red'>" + random_sample + "</font><b>"
        send_mail.send(msg)
        return jsonify({"msg": "", 'status': "200"})
    else:
        return jsonify({"msg": "检测到该邮箱已经被注册，一个邮箱只有一个创意手工艺品交易平台账号", 'status': "500"})


@user_dp.route("/about")
def about():
    userList = redis_cache.get('userList')
    if userList is None:
        users = User.query.filter(User.is_ok == 1).order_by(
            User.create_time.desc()).slice(0, 5)
        userList = []
        for user in users:
            user = User.user_json(user)
            userList.append(user)
        json_dumps = json.dumps(userList, ensure_ascii=False)
        print(json_dumps)
        redis_cache.set("userList", json_dumps)
    else:
        userList = userList.decode('utf8')
        userList = json.loads(userList)
        print(userList)
    return render_template("about.html", userList=userList)


@user_dp.route("/userInfo")
def userInfo():
    tab = request.args.get('tab')
    uid = session.get('uid')
    if uid is None:
        return redirect(url_for('user.login'))
    user = User.query.get(uid)
    
    # 如果是订单标签页，获取订单数据
    if tab == '3':
        # 获取用户的所有订单
        orders = Order.query.filter_by(uid=uid).order_by(Order.ordertime.desc()).all()
        print(f"用户 {user.username} 的订单数量: {len(orders)}")  # 调试信息
        
        # 处理每个订单的数据
        for order in orders:
            # 添加create_time属性用于显示
            order.create_time = order.ordertime
            # 添加status属性用于显示
            order.status = order.state
            
            # 计算订单总数量和总金额
            order.total_count = 0
            order.total_amount = order.total_money
            
            # 处理订单项的数据
            order.order_items = order.orderItems  # 确保使用正确的关系名称
            print(f"订单 {order.id} 的订单项数量: {len(order.orderItems)}")  # 调试信息
            
            for item in order.orderItems:
                order.total_count += item.count
                # 添加price和subtotal属性用于显示
                item.price = item.sub_total / item.count if item.count > 0 else 0
                item.subtotal = item.sub_total
                print(f"订单项 {item.id}: 商品ID={item.pid}, 数量={item.count}, 小计={item.sub_total}")  # 调试信息
                
            # 如果是待付款状态，计算剩余支付时间
            if order.state == 0:
                time_diff = (order.ordertime + timedelta(minutes=30)) - datetime.now()
                if time_diff.total_seconds() > 0:
                    minutes = int(time_diff.total_seconds() // 60)
                    seconds = int(time_diff.total_seconds() % 60)
                    order.last_time = f"{minutes}:{seconds:02d}"
                else:
                    # 如果超时，自动取消订单
                    order.state = 4
                    db.session.commit()
        
        return render_template('user/userInfo.html', user=user, tab=tab, orders=orders)
    
    # 如果是"我的发布"页面，获取用户发布的商品
    elif tab == '2':
        # 使用join加载商品和类别信息
        products = db.session.query(Product).join(CategorySecond, Product.csid == CategorySecond.id)\
            .filter(Product.uid == uid)\
            .add_entity(CategorySecond)\
            .all()
        
        # 处理查询结果
        formatted_products = []
        for product, category in products:
            product.category_name = category.csname  # 添加类别名称属性
            formatted_products.append(product)
            
        print(f"用户 {user.username} 的商品数量: {len(formatted_products)}")  # 调试信息
        return render_template('user/userInfo.html', user=user, tab=tab, products=formatted_products)
    
    return render_template('user/userInfo.html', user=user, tab=tab)


@user_dp.route("/changeHeadImage", methods=['POST'])
def changeHeadImage():
    from app import qiniu_store
    datas = request.form.get("datas")
    filename = str(uuid.uuid1()).replace("-", "") + ".jpg"
    try:
        img_data = base64.b64decode(datas)
        qiniu_store.save(img_data, filename=filename)
        img_url = QINIU_URL + filename
        uid = session.get('uid')
        user = User.query.get(uid)
        user.img_url = img_url
        db.session.commit()
        return jsonify({"error": '0'})
    except:
        return jsonify({"error": '1'})

@user_dp.route("/post_product", methods=['GET'])
def postProduct():
    uid = request.args.get("uid")
    products = Product.query.filter(Product.uid == uid, Product.is_pass == 2, Product.is_sell == 1).all()
    pd_dicts = []
    for product in products:
        pf_dict = {"id": product.id, "pname": product.pname, "head_img": product.head_img, "new_price": product.new_price}
        pd_dicts.append(pf_dict)
    return jsonify(pd_dicts)


@user_dp.route("/checkPassword", methods=['POST'])
def checkPassword():
    password = request.form.get('password')
    uid = session.get('uid')
    user = User.query.get(uid)
    flag = check_password_hash(user.password, password)

    return jsonify({'flag': flag})


@user_dp.route("/editUserInfo", methods=['POST'])
def editUserInfo():
    id = request.form.get("id")
    username = request.form.get("username")
    password = request.form.get("password")
    name = request.form.get("username")
    phone = request.form.get("phone")
    addr = request.form.get("addr")
    user = User.query.get(id)
    if password is not None and password != "":
        user.password = generate_password_hash(password)
    user.name = name
    user.phone = phone
    user.addr = addr
    db.session.commit()
    return jsonify()


@user_dp.route("/resetPassword")
def resetPassword():
    email = request.args.get('email')
    name = request.args.get('name')
    user = User.query.filter(User.email == email).first()
    if user is None:
        return jsonify({'status': 500, 'msg': '此邮箱无注册记录'})
    else:
        if user.username != name:
            return jsonify({"msg": "主人姓名不对呦~~~", 'status': "500"})
        else:
            random_sample = random.sample('1234567890abcdefghijklmnopqrstuvwxyz', 6)
            random_sample = ''.join(random_sample)
            user.password = generate_password_hash(random_sample)
            db.session.commit()
            msg = Message(subject="创意手工艺品交易平台找回密码", recipients=[email])
            msg.html = "<b><img src='http://127.0.0.1:5000/static/images/nyist.png" \
                       "style='width:260px'></b><br><b>创意手工艺品交易平台重置你的密码为:" \
                       "<font color='red'>" + random_sample + "</font>,建议登录之后修改密码，谢谢你的使用！<b>"
            send_mail.send(msg)
            return jsonify({"msg": "", 'status': "200"})


@user_dp.route("/provideOrders", methods=['POST'])
def provideOrders():
    uid = session.get('uid')
    if uid is None:
        return redirect(url_for('user.login'))
    user = User.query.get(uid)
    sp_ids = request.form.get("sp_ids")
    if sp_ids is not None:
        oid = str(uuid.uuid1()).replace('-', '')
        order = Order(id=oid, user=user, name="", phone="", addr="")
        db.session.commit()
        sp_ids = str(sp_ids).split('_')

        all_money = float(0)
        for sp_id in sp_ids:
            if sp_id is not None and len(sp_id) != 0:
                sp_id = str(sp_id)
                shopCart = ShopCart.query.get(sp_id)
                if shopCart is None:
                    continue
                if shopCart.pid is None:
                    return redirect(url_for('user.userInfo', tab=2))
                if shopCart is not None:
                    all_money += shopCart.subTotal
                    orderItem = OrderItem(id=shopCart.id, count=shopCart.count, sub_total=shopCart.subTotal,
                                          product=shopCart.product)
                    orderItem.order = order
                    db.session.delete(shopCart)
                    db.session.commit()
        user.shop_time = None
        order.total_money = all_money
        db.session.commit()
        return jsonify({"error": "0", "oid": order.id})
    return jsonify({"error": "1"})


@user_dp.route("/showOrder")
def showOrder():
    oid = request.args.get("oid")
    if oid is not None:
        order = Order.query.get(str(oid))
        if order is None:
            return redirect(url_for('index'))
        return render_template('order.html', order=order)


@user_dp.route("/")
def index():
    my_uid = session.get("uid")
    if my_uid is None:
        return redirect(url_for('index'))
    user = User.query.get(my_uid)
    if user.head_img:
        user.head_img = convert_qiniu_url(user.head_img)
    products = Product.query.filter(Product.uid == my_uid).all()
    for product in products:
        if product.images:
            product.images = convert_qiniu_url(product.images)
    return render_template("index.html", user=user, products=products)


@user_dp.route("/update_password_hash")
def update_password_hash():
    users = User.query.all()
    for user in users:
        if not user.password.startswith('pbkdf2:sha256:'):
            # 如果密码不是哈希值，则进行哈希处理
            plain_password = user.password
            user.password = generate_password_hash(plain_password)
            db.session.commit()
    return jsonify({"status": "200", "msg": "密码更新完成"})
