-- =============================================
-- 项目：Olist 电商数据分析
-- 模块：01 数据概况 基础查询
-- 功能：与 01_数据概况.md 步骤一一对应，可直接运行
-- =============================================

-- 1. 查看订单所有独立状态（去重）
SELECT DISTINCT order_status FROM orders;

-- 2. 统计订单表总行数
SELECT COUNT(*) FROM orders;

-- 3. 查询订单时间起止范围
SELECT
	MIN(order_purchase_timestamp) AS min_order_time,
	MAX(order_purchase_timestamp) AS max_order_time
FROM orders;

-- 4. 预览订单表前5行样例数据
SELECT * FROM orders LIMIT 5;

-- 5. 统计独立用户数
SELECT COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers;

-- 6. 统计订单项表总行数
SELECT COUNT(*) AS total_order_items
FROM order_items;

-- 7. 统计平台累计支付总金额
SELECT SUM(payment_value) AS total_payment_amount
FROM order_payments;

-- 8. 统计商品品类数量
SELECT COUNT(DISTINCT product_category_name) AS total_product_categories
FROM products;
