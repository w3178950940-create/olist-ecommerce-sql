-- 问题1：统计每月订单量（对应docs里的问题1）
SELECT 
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(DISTINCT order_id) AS order_count
FROM orders
WHERE order_status = 'delivered'
GROUP BY order_month
ORDER BY order_month;
