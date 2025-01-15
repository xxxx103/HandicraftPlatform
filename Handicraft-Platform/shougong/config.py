# coding = utf-8
import os

DEBUG = True

SECRET_KEY = "your-secret-key-keep-it-secret"
MAX_CONTENT_LENGTH = 16 * 1024 * 1024

# mysql配置
DIALECT = "mysql"
DRIVER = "pymysql"
USERNAME = "root"
PASSWORD = "123456"
HOST = "localhost"
PORT = "3306"
DATABASE = "new_shop"

SQLALCHEMY_DATABASE_URI = "{}+{}://{}:{}@{}:{}/{}?charset=utf8".format(DIALECT, DRIVER, USERNAME, PASSWORD, HOST, PORT,
                                                                       DATABASE)
SQLALCHEMY_TRACK_MODIFICATIONS = False

# qq邮箱配置

MAIL_SERVER = 'smtp.126.com'
MAIL_PROT = 25
MAIL_USE_TLS = True
MAIL_USE_SSL = False
MAIL_USERNAME = "wangjianlin1985@126.com"
MAIL_DEFAULT_SENDER = "wangjianlin1985@126.com"
MAIL_PASSWORD = "DBZTRUCHIYSUTDUG"
MAIL_DEBUG = True

# redis配置
REDIS_HOST = "localhost"
REDIS_PORT = 6379

# 七牛云配置
ALLOWED_EXT=set(['png', 'jpg','jpeg','bmp','gif'])
QINIU_ACCESS_KEY = "CkRFHlP7Cqwokja7-MBgeNsx7ovQY63VSwZk_As5"
QINIU_SECRET_KEY = "we-kdLG4tIhQgAphmmxvXFIZyq3-kju-MvHTGYrk"
QINIU_BUCKET_NAME = 'shougon-image'
QINIU_URL = "http://s237ckvv.hn-bkt.clouddn.com/"
QINIU_DOMAIN = "s237ckvv.hn-bkt.clouddn.com"
QINIU_SECURE_URL = False

# 七牛云域名映射
OLD_QINIU_DOMAIN = 'qiniuyun.donghao.club'
NEW_QINIU_DOMAIN = 's237ckvv.hn-bkt.clouddn.com'