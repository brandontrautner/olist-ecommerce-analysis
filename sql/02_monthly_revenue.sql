CREATE VIEW v_monthly_revenue
AS	
SELECT date_trunc('month'::TEXT, order_date) AS month
	,customer_state
	,sum(order_revenue) AS total_revenue
	,count(order_id) AS total_orders
FROM v_orders_complete
GROUP BY (date_trunc('month'::TEXT, order_date))
	,customer_state
ORDER BY (date_trunc('month'::TEXT, order_date))
	,customer_state;
