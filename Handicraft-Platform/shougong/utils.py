from config import OLD_QINIU_DOMAIN, NEW_QINIU_DOMAIN, QINIU_SECURE_URL

def convert_qiniu_url(url):
    """
    将旧的七牛云域名转换为新域名，使用 HTTP 协议
    :param url: 原始URL
    :return: 转换后的URL
    """
    if not url:
        return url
        
    # 处理多个URL（以@分隔的情况）
    if '@' in url:
        urls = url.split('@')
        return '@'.join(convert_qiniu_url(single_url) for single_url in urls if single_url.strip())
        
    # 替换域名
    url = url.replace(OLD_QINIU_DOMAIN, NEW_QINIU_DOMAIN)
    
    # 确保使用 HTTP 协议
    if url.startswith('https://'):
        url = 'http://' + url[8:]
    elif not url.startswith('http://'):
        url = 'http://' + url
    
    # 添加时间戳参数来避免缓存
    from time import time
    url += ('?' if '?' not in url else '&') + f'_t={int(time())}'
        
    return url 