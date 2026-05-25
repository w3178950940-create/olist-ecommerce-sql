/*
 * 文档名称：索引与SQL优化实战代码
 * 功能说明：基于EXPLAIN执行计划完成SQL性能调优
 * 优化流程：执行计划分析 → 创建索引 → 优化效果验证
 * 覆盖场景：多表内连接聚合、榜单查询、时间维度统计、左连接查询
 */

-- =============================================
-- 案例1：各地区销售额与订单量统计（多表INNER JOIN + 分组排序）
-- =============================================
-- 优化前：分析原始SQL执行计划
EXPLAIN
SELECT
  c.customer_state,
  ROUND(SUM(op.payment_value), 2) AS state_sales,
  COUNT(DISTINCT o.order_id) AS state_orders
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN order_payments op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY state_sales DESC;

-- 创建复合索引，优化筛选、关联、分组、聚合逻辑
CREATE INDEX idx_orders_status_customer ON orders(order_status, customer_id, order_id);
CREATE INDEX idx_customers_id_state ON customers(customer_id, customer_state);
CREATE INDEX idx_payments_id_value ON order_payments(order_id, payment_value);

-- 优化后：验证执行计划
EXPLAIN
SELECT
  c.customer_state,
  ROUND(SUM(op.payment_value), 2) AS state_sales,
  COUNT(DISTINCT o.order_id) AS state_orders
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN order_payments op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY state_sales DESC;

-- =============================================
-- 案例2：商品品类销售额TOP10（多表INNER JOIN + 聚合排行）
-- =============================================
-- 优化前：分析原始SQL执行计划
EXPLAIN
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

-- 创建复合索引，适配三表关联与聚合排序场景
CREATE INDEX idx_order_items_order_price ON order_items(order_id, product_id, price);
CREATE INDEX idx_products_id_category ON products(product_id, product_category_name);
CREATE INDEX idx_orders_status_id ON orders(order_status, order_id);

-- 优化后：验证执行计划
EXPLAIN
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

-- =============================================
-- 案例3：按小时统计平台GMV（时间函数 + 分组统计）
-- =============================================
-- 优化前：分析原始SQL执行计划
EXPLAIN
SELECT
  HOUR(o.order_approved_at) AS order_hour,
  ROUND(SUM(op.payment_value), 2) AS total_gmv
FROM orders o
INNER JOIN order_payments op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
  AND o.order_approved_at IS NOT NULL
GROUP BY order_hour
ORDER BY order_hour;

-- 创建复合索引，适配筛选、时间字段、关联与聚合场景
CREATE INDEX idx_orders_status_approved ON orders(order_status, order_approved_at, order_id);
CREATE INDEX idx_payments_id_val ON order_payments(order_id, payment_value);

-- 优化后：验证执行计划
EXPLAIN
SELECT
  HOUR(o.order_approved_at) AS order_hour,
  ROUND(SUM(op.payment_value), 2) AS total_gmv
FROM orders o
INNER JOIN order_payments op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
  AND o.order_approved_at IS NOT NULL
GROUP BY order_hour
ORDER BY order_hour;

-- =============================================
-- 案例4：订单与评价关联查询（LEFT JOIN 左连接场景）
-- =============================================
-- 优化前：分析原始SQL执行计划
EXPLAIN
SELECT
  o.order_id,
  rv.review_score
FROM orders o
LEFT JOIN order_reviews rv ON o.order_id = rv.order_id
WHERE o.order_status = 'delivered';

-- 创建索引，适配左连接查询与筛选条件
CREATE INDEX idx_orders_status ON orders(order_status, order_id);
CREATE INDEX idx_reviews_orderid ON order_reviews(order_id, review_score);

-- 优化后：验证执行计划
EXPLAIN
SELECT
  o.order_id,
  rv.review_score
FROM orders o
LEFT JOIN order_reviews rv ON o.order_id = rv.order_id
WHERE o.order_status = 'delivered';

-- =============================================
-- 索引运维管理（测试环境复用、环境还原）
-- =============================================
-- 查看数据表已存在索引，校验索引创建状态
SHOW INDEX FROM orders;
SHOW INDEX FROM customers;
SHOW INDEX FROM order_payments;
SHOW INDEX FROM order_items;
SHOW INDEX FROM products;
SHOW INDEX FROM order_reviews;

-- 删除测试索引，还原数据表初始状态（重复调试时使用）
DROP INDEX idx_orders_status_customer ON orders;
DROP INDEX idx_customers_id_state ON customers;
DROP INDEX idx_payments_id_value ON order_payments;
DROP INDEX idx_order_items_order_price ON order_items;
DROP INDEX idx_products_id_category ON products;
DROP INDEX idx_orders_status_id ON orders;
DROP INDEX idx_orders_status_approved ON orders;
DROP INDEX idx_payments_id_val ON order_payments;
DROP INDEX idx_orders_status ON orders;
DROP INDEX idx_reviews_orderid ON order_reviews;
