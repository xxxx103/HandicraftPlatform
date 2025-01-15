from flask import Blueprint, request, g, render_template, jsonify
from flask_login import login_required
from datetime import datetime, timedelta
from shouhong_mall.models import User, Order, OrderItem, Product, db

user_bp = Blueprint('user', __name__)

@user_bp.route('/userInfo')
@login_required
def userInfo():
    tab = request.args.get('tab')
    user = g.user
    
    # 如果是订单标签页，获取订单数据
    if tab == '3':
        # 获取用户的所有订单
        orders = Order.query.filter_by(user_id=user.id).order_by(Order.create_time.desc()).all()
        
        # 处理每个订单的数据
        for order in orders:
            # 获取订单项
            order.order_items = OrderItem.query.filter_by(order_id=order.id).all()
            
            # 计算订单总数量和总金额
            order.total_count = sum(item.count for item in order.order_items)
            order.total_amount = sum(item.subtotal for item in order.order_items)
            
            # 如果是待付款状态，计算剩余支付时间
            if order.status == 0:
                create_time = datetime.strptime(order.create_time, "%Y-%m-%d %H:%M:%S")
                now = datetime.now()
                time_diff = (create_time + timedelta(minutes=30)) - now
                if time_diff.total_seconds() > 0:
                    minutes = int(time_diff.total_seconds() // 60)
                    seconds = int(time_diff.total_seconds() % 60)
                    order.last_time = f"{minutes}:{seconds:02d}"
                else:
                    # 如果超时，自动取消订单
                    order.status = 4
                    db.session.commit()
            
            # 处理订单项的数据
            for item in order.order_items:
                item.product = Product.query.get(item.product_id)
                item.subtotal = item.price * item.count
        
        return render_template('user/userinfo.html', user=user, tab=tab, orders=orders)
    
    return render_template('user/userinfo.html', user=user, tab=tab)

@user_bp.route('/checkPassword', methods=['POST'])
@login_required
def check_password():
    """检查密码是否正确"""
    password = request.form.get('password')
    if not password:
        return jsonify({'flag': False})
    
    if user.check_password(password):
        return jsonify({'flag': True})
    return jsonify({'flag': False})

@user_bp.route('/editUserInfo', methods=['POST'])
@login_required
def edit_user_info():
    """修改用户信息"""
    user = g.user
    username = request.form.get('username')
    phone = request.form.get('phone')
    addr = request.form.get('addr')
    password = request.form.get('password')
    
    if username:
        user.username = username
    if phone:
        user.phone = phone
    if addr:
        user.addr = addr
    if password:
        user.set_password(password)
    
    try:
        db.session.commit()
        return jsonify({'status': '200', 'msg': '修改成功'})
    except:
        db.session.rollback()
        return jsonify({'status': '400', 'msg': '修改失败'})

@user_bp.route('/changeHeadImage', methods=['POST'])
@login_required
def change_head_image():
    """更换头像"""
    image_data = request.form.get('datas')
    if not image_data:
        return jsonify({'error': 1})
    
    try:
        # 这里需要实现保存图片的逻辑
        # 保存成功后更新用户头像地址
        user = g.user
        user.img_url = '新的头像地址'
        db.session.commit()
        return jsonify({'error': 0})
    except:
        db.session.rollback()
        return jsonify({'error': 1})
 