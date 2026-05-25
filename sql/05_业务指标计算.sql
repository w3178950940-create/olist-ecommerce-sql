-- =============================================
-- 05_核心业务指标计算
-- 电商最核心指标：GMV、订单量、客单价、用户数、复购率
-- =============================================

-- 1. 平台总 GMV（总成交金额）
SELECT
ROUND(SUM(payment_value), 2) AS total_gmv
FROM order_payments;

-- 2. 平台总有效订单量（已交付）
SELECT
COUNT(DISTINCT order_id) AS total_orders
FROM orders
WHERE order_status = 'delivered';

-- 3. 平台客单价（GMV / 有效订单数）
SELECT
ROUND(SUM(op.payment_value) / COUNT(DISTINCT o.order_id),2) AS avg_order_price
FROM orders o
INNER JOIN order_payments op
ON o.order_id = op.order_id
WHERE o.order_status = 'delivered';

-- 4. 平台累计消费用户数
SELECT
COUNT(DISTINCT c.customer_unique_id) AS total_buy_users
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered';

-- 5. 各月 GMV（按月统计）
SELECT
DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
ROUND(SUM(op.payment_value), 2) AS monthly_gmv
FROM orders o
INNER JOIN order_payments op
ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;

-- 6. 各月订单量
SELECT
DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
COUNT(DISTINCT o.order_id) AS monthly_orders
FROM orders o
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;

-- 7. 各商品品类销售额 TOP10
SELECT
p.product_category_name,
ROUND(SUM(oi.price), 2) AS category_sales,
COUNT(DISTINCT o.order_id) AS category_orders
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY p.product_category_name
ORDER BY category_sales DESC
LIMIT 10;

-- 8. 各州销售额 TOP10
SELECT
c.customer_state,
ROUND(SUM(op.payment_value), 2) AS state_sales,
COUNT(DISTINCT o.order_id) AS state_orders
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN order_payments op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY state_sales DESC
LIMIT 10;
