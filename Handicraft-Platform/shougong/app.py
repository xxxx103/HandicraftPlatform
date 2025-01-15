from flask import Flask, render_template, session, redirect, url_for, request
from apscheduler.schedulers.background import BackgroundScheduler
from extend import db, qiniu_store
import json
from datetime import timedelta
from blueprint.user import user_dp
from blueprint.validate_code import validate_code
from mail import send_mail
import config
import datetime
from pojo import *
from redis_cache import redis_cache, set_product_cache, clear_all_product_cache
from blueprint.product import product_dp
from utils import convert_qiniu_url

app = Flask(__name__)
app.jinja_env.add_extension('jinja2.ext.loopcontrols')
app.register_blueprint(user_dp)
app.register_blueprint(validate_code)
app.register_blueprint(product_dp)

app.config.from_object(config)
db.init_app(app)
qiniu_store.init_app(app)
send_mail.init_app(app)

with app.app_context():
    db.create_all()


@app.route('/')
def index():
    productList = redis_cache.get('productList')
    productList1 = redis_cache.get('productList1')
    productList2 = redis_cache.get('productList2')
    productList3 = redis_cache.get('productList3')
    category = Category.query.all()
    # 热门产品
    if productList is None:
        products = Product.query.filter(Product.is_sell == 1, Product.is_pass == 2, Product.counts != 0).order_by(
            Product.click_count.desc()).slice(0, 10)
        productList = []
        for product in products:
            product_dict = Product.product_json(product)
            if product_dict.get("head_img"):
                product_dict["head_img"] = convert_qiniu_url(product_dict["head_img"])
            productList.append(product_dict)
        json_dumps = json.dumps(productList, ensure_ascii=False)
        set_product_cache("productList", json_dumps)
    else:
        productList = productList.decode('utf8')
        productList = json.loads(productList)
        for product in productList:
            if product.get("head_img"):
                product["head_img"] = convert_qiniu_url(product["head_img"])
    # 新产品
    if productList1 is None:
        products = Product.query.filter(Product.is_sell == 1, Product.is_pass == 2, Product.counts != 0).order_by(
            Product.pdate.desc()).slice(0, 10)
        productList1 = []
        for product in products:
            product_dict = Product.product_json(product)
            if product_dict.get("head_img"):
                product_dict["head_img"] = convert_qiniu_url(product_dict["head_img"])
            productList1.append(product_dict)
        json_dumps = json.dumps(productList1, ensure_ascii=False)
        set_product_cache("productList1", json_dumps)
    else:
        productList1 = productList1.decode('utf8')
        productList1 = json.loads(productList1)
        for product in productList1:
            if product.get("head_img"):
                product["head_img"] = convert_qiniu_url(product["head_img"])
    # 轮播图商品
    if productList2 is None:
        products = Product.query.filter(Product.is_hot == 2, Product.is_sell == 1, Product.is_pass == 2, Product.counts != 0).order_by(
            Product.pdate.desc()).slice(0, 3)
        productList2 = []
        for product in products:
            product_dict = Product.product_json(product)
            if product_dict.get("head_img"):
                product_dict["head_img"] = convert_qiniu_url(product_dict["head_img"])
            productList2.append(product_dict)
        json_dumps = json.dumps(productList2, ensure_ascii=False)
        set_product_cache("productList2", json_dumps)
    else:
        productList2 = productList2.decode('utf8')
        productList2 = json.loads(productList2)
        for product in productList2:
            if product.get("head_img"):
                product["head_img"] = convert_qiniu_url(product["head_img"])
    # 最低价商品
    if productList3 is None:
        products = Product.query.filter(Product.is_sell == 1, Product.is_pass == 2, Product.counts != 0).order_by(
            Product.new_price.asc()).slice(0, 6)
        productList3 = []
        for product in products:
            product_dict = Product.product_json(product)
            if product_dict.get("head_img"):
                product_dict["head_img"] = convert_qiniu_url(product_dict["head_img"])
            productList3.append(product_dict)
        json_dumps = json.dumps(productList3, ensure_ascii=False)
        set_product_cache("productList3", json_dumps)
    else:
        productList3 = productList3.decode('utf8')
        productList3 = json.loads(productList3)
        for product in productList3:
            if product.get("head_img"):
                product["head_img"] = convert_qiniu_url(product["head_img"])
    return render_template('user/index.html', hot_products=productList, new_products=productList1,
                           extend_products=productList2, comment_products=productList3, categorys=category)


@app.route("/admin")
def adminProducts():
    uid = session.get("uid")
    if uid is not None:
        user = User.query.get(uid)
        if user.identity == 1:
            products = Product.query.filter(Product.is_pass == 0).order_by(
                Product.pdate.desc())
            productList = []
            for product in products:
                product_dict = Product.product_json2(product)
                if product_dict.get("images"):
                    product_dict["images"] = convert_qiniu_url(product_dict["images"])
                productList.append(product_dict)
            return render_template('admin/list.html', productList=productList)

    return render_template('loginUI.html')


@app.context_processor
def my_context_processor():
    category_all = Category.query.all()
    categoryList = redis_cache.get('categoryList')
    if categoryList is None:
        categorys = Category.query.all()
        categoryList = []
        for category in categorys:
            category = Category.category_json(category)
            categoryList.append(category)
        json_dumps = json.dumps(categoryList, ensure_ascii=False)
        print(json_dumps)
        redis_cache.set("categoryList", json_dumps)
    else:
        categoryList = categoryList.decode('utf8')
        categoryList = json.loads(categoryList)
        print(categoryList)
    uid = session.get("uid")
    last_time = ""
    if uid is not None:
        user = User.query.get(uid)
        if user.shop_time is not None:
            shop_time = user.shop_time
            offset = timedelta(minutes=20)
            result_time = (shop_time + offset) - datetime.now()
            if result_time.days < 0:
                for shopCart in user.shopcarts:
                    product = Product.query.get(shopCart.pid)
                    product.counts = product.counts + shopCart.count
                    db.session.delete(shopCart)
                    db.session.commit()
                user.shop_time is None
                db.session.commit()
                last_time = ""
            else:
                m, s = divmod(result_time.seconds, 60)
                last_time = "" + str(m) + ":" + str(s)
        length = 0
        for shopCart in user.shopcarts:
            length += shopCart.count

        return {"uid": uid, "username": user.username, 'user_img': convert_qiniu_url(user.img_url), "categorys": categoryList,
                "category_all": category_all, "last_time": last_time, "length": length, "user": user}
    else:
        return {"categorys": categoryList, "category_all": category_all, "uid": "", "length": "0"}


def hot_product():
    redis_cache.delete('productList')
    products = Product.query.filter(Product.is_sell == 1, Product.is_pass == 2).order_by(
        Product.click_count.desc()).slice(0, 10)
    productList = []
    for product in products:
        product_dict = Product.product_json(product)
        if product_dict["images"]:
            product_dict["images"] = convert_qiniu_url(product_dict["images"])
        productList.append(product_dict)
    json_dumps = json.dumps(productList, ensure_ascii=False)
    print(json_dumps)
    redis_cache.set("productList", json_dumps)


def clear_redis():
    """
    定期清理缓存
    """
    # 清理所有商品相关缓存
    clear_all_product_cache()
    # 清理用户列表缓存
    redis_cache.delete("userList")
    # 清理分类缓存
    redis_cache.delete("categoryList")


@app.errorhandler(404)
def not_foundPage(error):
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run()

scheduler = BackgroundScheduler()
# 每30分钟更新热门商品
scheduler.add_job(hot_product, 'interval', minutes=30)
# 每10分钟清理一次缓存
scheduler.add_job(clear_redis, 'interval', minutes=10)
scheduler.start()
