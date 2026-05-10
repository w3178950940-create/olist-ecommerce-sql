# Olist 电商数据集理解

## 项目背景

本项目基于 Olist 巴西电商平台公开数据集，围绕电商订单全生命周期展开分析。

项目目标包括：

- 用户分析
- 商品分析
- 订单分析
- GMV分析
- 用户行为分析
- BI可视化分析

---

# 数据表结构

本项目共使用 7 张核心业务表。

## 1. customers

用户基础信息表。

核心字段：

- customer_id：用户ID
- customer_unique_id：用户唯一标识
- customer_city：城市
- customer_state：州

业务意义：

用于分析用户地域分布、用户规模等。

---

## 2. orders

订单主表。

核心字段：

- order_id
- customer_id
- order_status
- order_purchase_timestamp

业务意义：

用于分析订单状态、订单趋势等。

---

## 3. order_payments

订单支付表。

核心字段：

- payment_value
- payment_type

业务意义：

用于分析 GMV、支付方式等。

---

# 数据关系

核心关联关系：

customers
↓
orders
↓
order_items
↓
products

orders
↓
order_payments

orders
↓
order_reviews

所有表通过 order_id 或 customer_id 关联。
