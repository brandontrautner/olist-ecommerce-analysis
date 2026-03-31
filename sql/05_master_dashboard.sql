CREATE VIEW v_master_dashboard
AS
SELECT order_id
	,customer_id
	,customer_state
	,customer_city
	,order_date
	,delivered_date
	,estimated_delivery_date
	,order_revenue
	,freight_value
	,item_count
	,payment_types
	,total_payment_value
	,review_score
	,date_trunc('month'::TEXT, order_date) AS order_month
	,CASE 
		WHEN delivered_date <= estimated_delivery_date
			THEN 'On Time'::TEXT
		ELSE 'Late'::TEXT
		END AS delivery_status
FROM v_orders_complete o;
