from flask import Blueprint, render_template, request, jsonify, session, g
from shouhong_mall.models import Product, Cart, db
from shouhong_mall.utils.common import login_required

@product_bp.route("/addCart", methods=["POST"])
@login_required
def add_cart():
    """添加购物车"""
    if request.method == "POST":
        pid = request.form.get("pid")
        count = int(request.form.get("count", 1))
        
        if not all([pid, count]):
            return jsonify({"status": "400", "msg": "参数不完整"})
            
        product = Product.query.get(pid)
        if not product:
            return jsonify({"status": "400", "msg": "商品不存在"})
            
        if product.stock < count:
            return jsonify({"status": "400", "msg": "库存不足"})
            
        # 查询购物车中是否已存在该商品
        cart_item = Cart.query.filter_by(user_id=g.user.id, product_id=pid).first()
        
        if cart_item:
            # 如果存在则更新数量
            cart_item.count += count
            if cart_item.count > product.stock:
                return jsonify({"status": "400", "msg": "库存不足"})
        else:
            # 不存在则新建购物车项
            cart_item = Cart(
                user_id=g.user.id,
                product_id=pid,
                count=count
            )
            db.session.add(cart_item)
            
        try:
            db.session.commit()
            return jsonify({"status": "200", "msg": "添加成功"})
        except Exception as e:
            db.session.rollback()
            return jsonify({"status": "400", "msg": "添加失败"})
            
    return jsonify({"status": "400", "msg": "请求方式错误"})

@product_bp.route("/cart")
@login_required
def cart():
    """购物车页面"""
    # 查询用户的购物车商品
    cart_items = Cart.query.filter_by(user_id=g.user.id).all()
    total_price = 0
    
    # 计算总价
    for item in cart_items:
        product = Product.query.get(item.product_id)
        if product:
            item.product = product
            item.subtotal = product.price * item.count
            total_price += item.subtotal
            
    return render_template("cart.html", cart_items=cart_items, total_price=total_price) 

@product_bp.route("/updateCart", methods=["POST"])
@login_required
def update_cart():
    """更新购物车商品数量"""
    if request.method == "POST":
        pid = request.form.get("pid")
        count = int(request.form.get("count", 1))
        
        if not all([pid, count]):
            return jsonify({"status": "400", "msg": "参数不完整"})
            
        product = Product.query.get(pid)
        if not product:
            return jsonify({"status": "400", "msg": "商品不存在"})
            
        if product.stock < count:
            return jsonify({"status": "400", "msg": "库存不足"})
            
        cart_item = Cart.query.filter_by(user_id=g.user.id, product_id=pid).first()
        if not cart_item:
            return jsonify({"status": "400", "msg": "购物车中没有该商品"})
            
        cart_item.count = count
        
        try:
            db.session.commit()
            return jsonify({"status": "200", "msg": "更新成功"})
        except Exception as e:
            db.session.rollback()
            return jsonify({"status": "400", "msg": "更新失败"})
            
    return jsonify({"status": "400", "msg": "请求方式错误"})

@product_bp.route("/removeCart", methods=["POST"])
@login_required
def remove_cart():
    """删除购物车商品"""
    if request.method == "POST":
        pid = request.form.get("pid")
        
        if not pid:
            return jsonify({"status": "400", "msg": "参数不完整"})
            
        cart_item = Cart.query.filter_by(user_id=g.user.id, product_id=pid).first()
        if not cart_item:
            return jsonify({"status": "400", "msg": "购物车中没有该商品"})
            
        try:
            db.session.delete(cart_item)
            db.session.commit()
            return jsonify({"status": "200", "msg": "删除成功"})
        except Exception as e:
            db.session.rollback()
            return jsonify({"status": "400", "msg": "删除失败"})
            
    return jsonify({"status": "400", "msg": "请求方式错误"}) 