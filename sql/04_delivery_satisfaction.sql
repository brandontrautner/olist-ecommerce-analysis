SELECT customer_state
	,CASE 
		WHEN delivered_date <= estimated_delivery_date
			THEN 'On Time'::TEXT
		ELSE 'Late'::TEXT
		END AS delivery_status
	,round(avg(review_score), 2) AS avg_review_score
	,count(review_score) AS reviewed_orders
FROM v_orders_complete
GROUP BY customer_state
	,(
		CASE 
			WHEN delivered_date <= estimated_delivery_date
				THEN 'On Time'::TEXT
			ELSE 'Late'::TEXT
			END
		);
