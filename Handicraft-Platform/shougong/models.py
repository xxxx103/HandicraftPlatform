class User(UserMixin, db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    username = db.Column(db.String(50), nullable=False)
    password = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(50), nullable=False, unique=True)
    phone = db.Column(db.String(11))
    addr = db.Column(db.String(100))
    identity = db.Column(db.Integer, default=0)  # 0普通用户 1会员
    img_url = db.Column(db.String(100), default='static/images/default_avatar.png')
    
    # 关联关系
    shopcarts = db.relationship('ShopCart', backref='user', lazy=True)
    orders = db.relationship('Order', backref='user', lazy=True)
    products = db.relationship('Product', backref='user', lazy=True)
    
    def __init__(self, username, password, email):
        self.username = username
        self.password = password
        self.email = email 

class Product(db.Model):
    __tablename__ = 'product'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    pname = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text)
    price = db.Column(db.Float, nullable=False)
    stock = db.Column(db.Integer, default=0)
    sales = db.Column(db.Integer, default=0)
    status = db.Column(db.Integer, default=0)  # 0待审核 1已上架 2已下架 3审核未通过
    head_img = db.Column(db.String(200))
    create_time = db.Column(db.DateTime, default=datetime.now)
    category_id = db.Column(db.Integer, db.ForeignKey('category.id'))
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    
    # 关联关系
    category = db.relationship('Category', backref='products')
    order_items = db.relationship('OrderItem', backref='product', lazy=True)
    shopcarts = db.relationship('ShopCart', backref='product', lazy=True) 