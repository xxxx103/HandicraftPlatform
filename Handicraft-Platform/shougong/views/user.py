from flask import Blueprint, request, render_template, flash, redirect, url_for
from flask_login import login_required, current_user
from shouhong_mall.models import User, Product, Order
from shouhong_mall.extensions import db

user_bp = Blueprint('user', __name__)

@user_bp.route('/userinfo')
@login_required
def userinfo():
    tab = request.args.get('tab')
    # 使用 joinedload 预加载关联数据
    user = User.query.get(current_user.id)
    
    if tab == '3':
        # 获取用户的订单，使用关联关系
        orders = user.orders
        print(f"用户 {user.username} 的订单数量: {len(orders)}")  # 添加调试信息
        return render_template('user/userInfo.html', user=user, tab=tab, orders=orders)
    
    # 如果是"我的发布"页面，直接查询用户的商品
    if tab == '2':
        # 直接通过uid查询商品
        products = Product.query.filter_by(uid=user.id).order_by(Product.pdate.desc()).all()
        print(f"用户 {user.username} 的商品数量: {len(products)}")  # 添加调试信息
        # 确保products变量始终存在，即使是空列表
        return render_template('user/userInfo.html', user=user, tab=tab, products=products or [])
    
    return render_template('user/userInfo.html', user=user, tab=tab) 