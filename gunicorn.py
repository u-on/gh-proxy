# gunicorn.py
import logging
import logging.handlers
from logging.handlers import WatchedFileHandler
import os
import multiprocessing

# 绑定ip和端口号
bind = '127.0.0.1:8080'

# keyfile = 'ssl.key'
# certfile = 'ssl.crt'

# ca_certs = 'chain.crt'
backlog = 1024  # 监听队列
chdir = '/opt/gh-proxy'
# preload_app = True  # 预加载资源
# daemon = True  # 如果不使用supervisord之类的进程管理工具可以是进程成为守护进程，否则会出问题
# 进程名称
proc_name = 'gunicorn.pid'

# 进程pid记录文件
# pidfile = './log/app_run.log'  # 设置pid文件的文件名，如果不设置将不会创建pid文件

# worker_class = 'gevent'  # 使用gevent模式，还可以使用sync 模式，默认的是sync模式
worker_class = 'egg:meinheld#gunicorn_worker'  # 比 gevent 更快的一个异步网络库

workers = multiprocessing.cpu_count() * 2 + 1  # 进程数
threads = multiprocessing.cpu_count() * 2  # 指定每个进程开启的线程数

keepalive = 2  # 默认2 服务器保持连接的时间，能够避免频繁的三次握手过程
timeout = 30  # 一个请求的超时时间
graceful_timeout = 30  # 重启时限
limit_request_field_size = 8190  # 限制HTTP请求中请求头的大小，默认情况下这个值为8190。值是一个整数或者0，当该值为0时，表示将对请求头大小不做限制
# forwarded_allow_ips = '*' # 允许哪些ip地址来访问

# 最大客户客户端并发数量,对使用线程和协程的worker的工作有影响
# worker_connections = 1200


'''
其每个选项的含义如下：
h          remote address
l          '-'
u          currently '-', may be user name in future releases
t          date of the request
r          status line (e.g. ``GET / HTTP/1.1``)
s          status
b          response length or '-'
f          referer
a          user agent
T          request time in seconds
D          request time in microseconds
L          request time in decimal seconds
p          process ID
'''

capture_output = True  # 是否捕获输出
#
# logfile = './log/debug.log'
# loglevel = 'info'  # 日志级别，这个日志级别指的是错误日志的级别，而访问日志的级别无法设置
# access_log_format = '%(t)s %(p)s %(h)s "%(r)s" %(s)s %(L)s %(b)s %(f)s" "%(a)s" "%({X-Real-IP}i)s"'  # 设置gunicorn访问日志格式，错误日志无法设置
# accesslog = "./log/gunicorn_access.log"  # 访问日志文件
# errorlog = "./log/gunicorn_error.log"  # 错误日志文件
