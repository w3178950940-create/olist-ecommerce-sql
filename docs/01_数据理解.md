# 01 数据理解

## 1.1 orders 订单主表

### 查看表结构

```sql
SELECT * FROM orders LIMIT 10;
order_id	customer_id	order_status	order_purchase_timestamp	order_approved_at	order_delivered_carrier_date	order_delivered_customer_date	order_estimated_delivery_date
e481f51cbdc54678b7cc49136f2d6af7	9ef432eb6251297304e76186b10a928d	delivered	2017-10-02 10:56:33	2017-10-02 11:07:15	2017-10-04 19:55:00	2017-10-10 21:25:13	2017-10-18 00:00:00
53cdb2fc8bc7dce0b6741e2150273451	b0830fb4747a6c6d20dea0b8c802d7ef	delivered	2018-07-24 20:41:37	2018-07-26 03:24:27	2018-07-26 14:31:00	2018-08-07 15:27:45	2018-08-13 00:00:00
47770eb9100c2d0c44946d9cf07ec65d	41ce2a54c0b03bf3443c3d931a367089	delivered	2018-08-08 08:38:49	2018-08-08 08:55:23	2018-08-08 13:50:00	2018-08-17 18:06:29	2018-09-04 00:00:00
949d5b27dc9255a5add7bd2f53bc60f6	f88197465ea7920ad1bec8cf766b5d4a	delivered	2017-11-18 19:28:06	2017-11-18 19:45:59	2017-11-22 13:39:59	2017-12-02 00:28:42	2017-12-15 00:00:00
b0333fe05901099a697cf86b6e0c502d	776f6b27f65c99f960eb1ae7349a0f13	delivered	2018-02-03 08:57:51	2018-02-03 09:09:49	2018-02-05 14:21:00	2018-02-16 19:15:13	2018-03-01 00:00:00
41cb0d4b36dc6e0b23014c9b05f8793d	abae57f187100bb700fe50b0fdb9c191	delivered	2018-01-29 13:39:36	2018-01-29 13:45:49	2018-02-02 22:16:49	2018-02-12 16:54:12	2018-02-22 00:00:00
16fbed1c10ef801dbd6934a21b1c16c3	185e67d62e7ee7e17b6a5c51da1b70c2	delivered	2017-10-26 11:07:42	2017-10-26 12:26:36	2017-10-27 14:32:29	2017-11-08 14:01:51	2017-11-20 00:00:00
cf262f20cedd094b05300af66788a4f6	44306b63ee8703437db04b41e12f6fbb	delivered	2018-05-18 17:20:55	2018-05-19 12:42:12	2018-05-21 21:42:27	2018-05-25 14:11:33	2018-06-04 00:00:00
b25597f407672074163389b9f77386f0	2c7212a470d0cc4f2df7587bd8de7041	delivered	2018-04-14 17:35:56	2018-04-14 19:02:40	2018-04-17 13:51:43	2018-04-27 19:17:33	2018-05-08 00:00:00
de6d485a9f9467db873e41f953fbb63e	bd4c91e1756cb7b84f47b59af1a44f3e	shipped	2018-02-28 22:41:26	2018-03-01 04:33:27	2018-03-06 23:04:24	无	2018-03-19 00:00:00
字段说明
字段名	含义	示例值
order_id	订单唯一ID	e481f51cbdc...
customer_id	用户ID	9ef432eb62...
order_status	订单状态	delivered
order_purchase_timestamp	下单时间	2017-10-02 10:56:33
order_approved_at	审核通过时间	2017-10-02 11:07:15
order_delivered_carrier_date	交承运商时间	2017-10-04 19:55:00
order_delivered_customer_date	实际送达时间	2017-10-10 21:25:13
order_estimated_delivery_date	预计送达时间	2017-10-18 00:00:00
订单状态分布
sql
SELECT DISTINCT order_status FROM orders;
order_status
delivered
shipped
processing
invoiced
unavailable
canceled
created
approved
状态含义
状态	含义	是否终态
created	已创建	否
approved	已审核	否
processing	处理中	否
invoiced	已开票	否
shipped	已发货	否
delivered	已送达	是
canceled	已取消	是
unavailable	不可用	是
订单总量
sql
SELECT COUNT(*) AS 总订单量 FROM orders;
总订单量
99441
时间范围
sql
SELECT 
    MIN(order_purchase_timestamp) AS 最早下单时间,
    MAX(order_purchase_timestamp) AS 最晚下单时间
FROM orders;
最早下单时间	最晚下单时间
2016-09-04 21:15:19	2018-10-17 17:29:33
小结：orders 表共 99441 条订单，时间跨度 2016年9月 至 2018年10月，约25个月。订单有8种状态，delivered 为最终完成状态。

1.2 order_payments 支付表
查看表结构
sql
SELECT * FROM order_payments LIMIT 10;
跑完SQL后把10行结果替换到这里

字段说明
字段名	含义
order_id	订单ID
payment_sequential	支付序号（一个订单可多次支付）
payment_type	支付方式
payment_installments	分期数
payment_value	支付金额
支付记录数
sql
SELECT COUNT(*) AS 总支付记录数 FROM order_payments;
SELECT COUNT(DISTINCT order_id) AS 有支付记录的订单数 FROM order_payments;
跑完SQL后把结果替换到这里

1.3 order_items 订单商品表
查看表结构
sql
SELECT * FROM order_items LIMIT 10;
跑完SQL后把10行结果替换到这里

字段说明
字段名	含义
order_id	订单ID
order_item_id	订单商品序号
product_id	商品ID
seller_id	卖家ID
shipping_limit_date	最晚发货日期
price	商品单价
freight_value	运费
商品记录数
sql
SELECT COUNT(*) AS 总商品记录数 FROM order_items;
跑完SQL后把结果替换到这里

1.4 products 商品表
查看表结构
sql
SELECT * FROM products LIMIT 10;
跑完SQL后把10行结果替换到这里

字段说明
字段名	含义
product_id	商品ID
product_category_name	商品品类（葡萄牙语）
product_name_lenght	商品名称长度
product_description_lenght	商品描述长度
product_photos_qty	商品图片数量
product_weight_g	商品重量(克)
product_length_cm	商品长度(厘米)
product_height_cm	商品高度(厘米)
product_width_cm	商品宽度(厘米)
商品总数
sql
SELECT COUNT(*) AS 总商品数 FROM products;
跑完SQL后把结果替换到这里

1.5 customers 用户表
查看表结构
sql
SELECT * FROM customers LIMIT 10;
跑完SQL后把10行结果替换到这里

字段说明
字段名	含义
customer_id	用户ID
customer_unique_id	用户去重标识
customer_zip_code_prefix	邮编前缀
customer_city	城市
customer_state	州
用户数
sql
SELECT COUNT(*) AS 总用户数 FROM customers;
SELECT COUNT(DISTINCT customer_unique_id) AS 去重用户数 FROM customers;
跑完SQL后把结果替换到这里

1.6 order_reviews 评价表
查看表结构
sql
SELECT * FROM order_reviews LIMIT 10;
跑完SQL后把10行结果替换到这里

字段说明
字段名	含义
review_id	评价ID
order_id	订单ID
review_score	评分(1-5)
review_comment_title	评价标题
review_comment_message	评价内容
review_creation_date	评价创建日期
review_answer_timestamp	商家回复时间
评价总数
sql
SELECT COUNT(*) AS 总评价数 FROM order_reviews;
跑完SQL后把结果替换到这里

1.7 category_translation 品类翻译表
查看表结构
sql
SELECT * FROM category_translation LIMIT 10;
跑完SQL后把10行结果替换到这里

字段说明
字段名	含义
product_category_name	品类名（葡萄牙语）
product_category_name_english	品类名（英文）
