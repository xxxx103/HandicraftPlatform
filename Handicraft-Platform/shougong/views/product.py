from flask import Blueprint, request, render_template, flash, redirect, url_for, jsonify, current_app
from flask_login import login_required, current_user
from werkzeug.utils import secure_filename
import os
from shouhong_mall.models import Product, Category
from shouhong_mall.utils import allowed_file
from shouhong_mall.extensions import db

product_bp = Blueprint('product', __name__)

@product_bp.route('/edit/<int:id>', methods=['GET', 'POST'])
@login_required
def edit(id):
    product = Product.query.get_or_404(id)
    # 检查是否是商品的发布者
    if product.user_id != current_user.id:
        flash('您没有权限编辑此商品')
        return redirect(url_for('main.index'))
    
    if request.method == 'POST':
        name = request.form.get('name')
        price = request.form.get('price')
        description = request.form.get('description')
        category_id = request.form.get('category')
        
        if not all([name, price, description, category_id]):
            flash('请填写所有必填字段')
            return redirect(url_for('product.edit', id=id))
        
        try:
            product.name = name
            product.price = float(price)
            product.description = description
            product.category_id = int(category_id)
            
            # 处理图片上传
            if 'image' in request.files:
                file = request.files['image']
                if file and allowed_file(file.filename):
                    filename = secure_filename(file.filename)
                    file.save(os.path.join(current_app.config['UPLOAD_FOLDER'], filename))
                    product.image = filename
            
            db.session.commit()
            flash('商品更新成功')
            return redirect(url_for('user.userinfo'))
        except Exception as e:
            db.session.rollback()
            flash('更新失败，请重试')
            return redirect(url_for('product.edit', id=id))
    
    categories = Category.query.all()
    return render_template('product/edit.html', product=product, categories=categories)

@product_bp.route('/delete/<int:id>', methods=['POST'])
@login_required
def delete(id):
    product = Product.query.get_or_404(id)
    if product.user_id != current_user.id:
        return jsonify({'code': 403, 'message': '您没有权限删除此商品'})
    
    try:
        # 如果商品有图片，删除图片文件
        if product.image:
            image_path = os.path.join(current_app.config['UPLOAD_FOLDER'], product.image)
            if os.path.exists(image_path):
                os.remove(image_path)
        
        db.session.delete(product)
        db.session.commit()
        return jsonify({'code': 200, 'message': '删除成功'})
    except Exception as e:
        db.session.rollback()
        return jsonify({'code': 500, 'message': '删除失败，请重试'}) 

@product_bp.route('/xj/<int:id>', methods=['POST'])
@login_required
def xj(id):
    product = Product.query.get_or_404(id)
    if product.user_id != current_user.id:
        return jsonify({'code': 403, 'message': '您没有权限下架此商品'})
    
    try:
        product.status = 2  # 更新状态为已下架
        db.session.commit()
        return jsonify({'code': 200, 'message': '下架成功'})
    except Exception as e:
        db.session.rollback()
        return jsonify({'code': 500, 'message': '下架失败，请重试'}) 

@product_bp.route('/repeat_check/<int:id>', methods=['POST'])
@login_required
def repeat_check(id):
    product = Product.query.get_or_404(id)
    if product.user_id != current_user.id:
        return jsonify({'code': 403, 'message': '您没有权限操作此商品'})
    
    try:
        product.status = 0  # 更新状态为待审核
        db.session.commit()
        return jsonify({'code': 200, 'message': '申请已提交，请等待审核'})
    except Exception as e:
        db.session.rollback()
        return jsonify({'code': 500, 'message': '操作失败，请重试'}) 

@product_bp.route('/publish', methods=['GET', 'POST'])
@login_required
def publish():
    if request.method == 'POST':
        name = request.form.get('name')
        price = request.form.get('price')
        description = request.form.get('description')
        category_id = request.form.get('category')
        stock = request.form.get('stock', 0)
        
        if not all([name, price, description, category_id]):
            flash('请填写所有必填字段')
            return redirect('/product/publish')
        
        try:
            product = Product(
                pname=name,
                price=float(price),
                description=description,
                category_id=int(category_id),
                stock=int(stock),
                user_id=current_user.id
            )
            
            # 处理图片上传
            if 'image' in request.files:
                file = request.files['image']
                if file and allowed_file(file.filename):
                    filename = secure_filename(file.filename)
                    file.save(os.path.join(current_app.config['UPLOAD_FOLDER'], filename))
                    product.head_img = filename
            
            db.session.add(product)
            db.session.commit()
            flash('商品发布成功，等待审核')
            return redirect('/user/userinfo?tab=2')
        except Exception as e:
            db.session.rollback()
            flash('发布失败，请重试')
            return redirect('/product/publish')
    
    categories = Category.query.all()
    return render_template('product/publish.html', categories=categories) 