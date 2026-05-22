-- =============================================
-- 02_数据清洗
-- 功能：缺失值、重复值、异常值检查
-- 仅单表查询，不做复杂关联
-- =============================================

-- 1. 订单表缺失值检查（收货时间）
SELECT
    COUNT(*) AS total,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS missing_deliver_date
FROM orders;

-- 未交付订单校验
SELECT 
  order_status,
  COUNT(*) AS order_count
FROM orders
WHERE order_delivered_customer_date IS NULL
GROUP BY order_status;

-- 2. 订单表重复订单ID检查
SELECT order_id, COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- 3. 用户表缺失值检查（州）
SELECT
    COUNT(*) AS total,
    SUM(CASE WHEN customer_state IS NULL THEN 1 ELSE 0 END) AS missing_state
FROM customers;

-- 4. 用户表唯一用户ID重复检查
SELECT customer_unique_id, COUNT(*)
FROM customers
GROUP BY customer_unique_id
HAVING COUNT(*) > 1;

-- 5. 订单项表异常价格检查（<=0）
SELECT *
FROM order_items
WHERE price <= 0;

-- 6. 支付表异常支付金额检查（<=0）
SELECT *
FROM order_payments
WHERE payment_value <= 0;

-- 验证支付金额=0的支付方式
SELECT payment_type, COUNT(*)
FROM order_payments
WHERE payment_value = 0
GROUP BY payment_type;

-- 7. 商品表品类缺失检查
SELECT
    COUNT(*) AS total,
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS missing_category
FROM products;

-- 8. 评价表缺失评分检查
SELECT
    COUNT(*) AS total,
    SUM(CASE WHEN review_score IS NULL THEN 1 ELSE 0 END) AS missing_score
FROM order_reviews;
