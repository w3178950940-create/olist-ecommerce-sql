-- =============================================
-- 04_多表关联分析
-- 核心：JOIN / LEFT JOIN 多表联合查询
-- 用途：订单+用户+支付+商品+评价 全链路关联
-- =============================================

-- 1. 订单 + 用户 关联（查看每个订单来自哪个州）
SELECT
  o.order_id,
  o.order_status,
  c.customer_id,
  c.customer_unique_id,
  c.customer_state
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id
LIMIT 20;

-- 2. 订单 + 支付 关联（每个订单的支付方式和金额）
SELECT
  o.order_id,
  o.order_status,
  op.payment_type,
  op.payment_value
FROM orders o
INNER JOIN order_payments op
ON o.order_id = op.order_id
LIMIT 20;

-- 3. 订单 + 订单项 + 商品 三表关联（订单买了什么商品）
SELECT
  o.order_id,
  oi.order_item_id,
  oi.price,
  p.product_id,
  p.product_category_name
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
LIMIT 20;

-- 4. 订单 + 评价 关联（订单是否有评分）
SELECT
  o.order_id,
  o.order_status,
  r.review_score
FROM orders o
LEFT JOIN order_reviews r
ON o.order_id = r.order_id
LIMIT 20;

-- 5. 五表大关联（订单+用户+支付+订单项+商品）
SELECT
  o.order_id,
  c.customer_state,
  op.payment_type,
  op.payment_value,
  oi.price,
  p.product_category_name
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN order_payments op ON o.order_id = op.order_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
LIMIT 20;
