CREATE VIEW v_orders_complete
AS
WITH payments_agg
AS (
	SELECT order_id
		,SUM(payment_value) AS total_payment_value
		,STRING_AGG(DISTINCT payment_type, ', ') AS payment_types
	FROM order_payments
	GROUP BY order_id
	)
	,reviews_agg
AS (
	SELECT DISTINCT ON (order_id) order_id
		,review_score
	FROM order_reviews
	ORDER BY order_id
		,review_creation_date DESC
	)
SELECT o.order_id
	,o.customer_id
	,o.order_purchase_timestamp::TIMESTAMP AS order_date
	,o.order_delivered_customer_date::TIMESTAMP AS delivered_date
	,o.order_estimated_delivery_date::TIMESTAMP AS estimated_delivery_date
	,c.customer_city
	,c.customer_state
	,COALESCE(SUM(oi.price), 0) AS order_revenue
	,COALESCE(SUM(oi.freight_value), 0) AS freight_value
	,COUNT(oi.order_item_id) AS item_count
	,p.payment_types
	,COALESCE(p.total_payment_value, 0) AS total_payment_value
	,r.review_score
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN payments_agg p ON o.order_id = p.order_id
LEFT JOIN reviews_agg r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY o.order_id
	,o.customer_id
	,o.order_purchase_timestamp
	,o.order_delivered_customer_date
	,o.order_estimated_delivery_date
	,c.customer_city
	,c.customer_state
	,p.payment_types
	,p.total_payment_value
	,r.review_score;

