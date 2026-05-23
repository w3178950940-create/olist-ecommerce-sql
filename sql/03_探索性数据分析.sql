-- =============================================
-- 03 探索性数据分析 EDA
-- 维度：时间趋势、订单状态、支付方式、评价评分、地域销量、品类销量
-- =============================================

-- 1. 订单下单时段分布分析
SELECT 
  HOUR(order_purchase_timestamp) AS order_hour,
  COUNT(order_id) AS order_num
FROM orders 
GROUP BY order_hour 
ORDER BY order_hour;

-- 2. 各订单状态数量分布
SELECT
  order_status,
  COUNT(order_id) AS order_num
FROM orders
GROUP BY order_status
ORDER BY order_num DESC;

-- 3. 各支付方式订单数 & 金额统计
SELECT
  payment_type,
  COUNT(*) AS order_count,
  ROUND(SUM(payment_value),2) AS total_amount
FROM order_payments
GROUP BY payment_type
ORDER BY order_count DESC;

-- 4. 评价分数分布统计
SELECT
  review_score,
  COUNT(*) AS review_count
FROM order_reviews
GROUP BY review_score
ORDER BY review_score DESC;

-- 5. 各用户所在州订单量排行
SELECT
  c.customer_state,
  COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY order_count DESC;

-- 6. 商品品类销量 TOP10
SELECT
  p.product_category_name,  -- 1. 维度：商品品类（来自商品表）
  COUNT(oi.order_id) AS sale_count  -- 2. 指标：统计每个品类的销量
FROM order_items oi  -- 3. 主表：订单项表（记录每一件卖出的商品，销量来源）
JOIN products p  -- 4. 关联商品表（拿品类名称）
  ON oi.product_id = p.product_id  -- 5. 关联条件：商品ID（外键）
GROUP BY p.product_category_name  -- 6. 按品类分组，分别统计销量
ORDER BY sale_count DESC  -- 7. 按销量从高到低排序
LIMIT 10;  -- 8. 只取前10名，就是销量TOP10
