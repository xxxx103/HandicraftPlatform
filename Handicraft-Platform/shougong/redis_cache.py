from redis import Redis

redis_cache = Redis(host='127.0.0.1', port=6379)

def clear_all_product_cache():
    """
    清除所有商品相关的缓存
    """
    keys = ["productList", "productList1", "productList2", "productList3"]
    for key in keys:
        redis_cache.delete(key)

def set_product_cache(key, value, expire_time=3600):
    """
    设置商品缓存，默认1小时过期
    """
    redis_cache.set(key, value, ex=expire_time)
