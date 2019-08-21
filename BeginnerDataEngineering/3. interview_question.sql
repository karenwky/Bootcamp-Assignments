/* 1. For hours with orders, how many orders are there each hour based on order time? */
SELECT HOUR(order_datetime), COUNT(*) AS Orders_Each_Hour
FROM vanorder
GROUP BY HOUR(order_datetime)
ORDER BY HOUR(order_datetime); 

/* 2. What is the percentage of money spent for each of the following group of clients?
	- Clients who completed 1 order
	- Clients who completed more than 1 order */
SELECT CLIENTS_GROUP, SUM(TP) * 100 / (
    SELECT SUM(total_price) 
    FROM vanorder 
    WHERE order_status = 2) AS Percentage
FROM
  (SELECT SUM(total_price) AS TP, 
  (CASE WHEN COUNT(requestor_client_id) = 1 THEN '1' ELSE '>1' END) AS CLIENTS_GROUP
  FROM vanorder
  WHERE order_status = 2
  GROUP BY requestor_client_id) AS Price
GROUP BY CLIENTS_GROUP;

/* 3. List of unique Client ID who completed at least one order, 
also show each client's total money spent, and the total order(s) completed. 
Order the list by total money spent (descending), then by total order(s) completed (descending) */
SELECT requestor_client_id, SUM(total_price) AS TotalPrice, COUNT(*) AS OrderCount
FROM vanorder
WHERE order_status = 2
GROUP BY requestor_client_id
ORDER BY TotalPrice DESC, OrderCount DESC, requestor_client_id ASC; 

/* 4. List of all drivers who took order(s) (regardless of whether they eventually complete the order), 
also show each driver's total income and total order(s) completed. 
Order the list by total income (descending), then by total order(s) completed */
SELECT servicer_auth as Driver_id, (IFNULL(SUM(total_price), 0)) as Total_income, 
	(IF(IFNULL(SUM(total_price), 0)=0, 0, COUNT(servicer_auth))) as Total_order_completed
FROM
	(SELECT unique_driver.servicer_auth, total_price 
	FROM
		(SELECT DISTINCT servicer_auth FROM vaninterest) AS unique_driver
	LEFT JOIN
		(SELECT vaninterest.idvanOrder, vaninterest.servicer_auth, vanorder.total_price 
		FROM vaninterest 
		INNER JOIN vanorder ON vaninterest.servicer_auth = vanorder.servicer_auth
		WHERE vanorder.order_status = 2) as completed
	ON (unique_driver.servicer_auth = completed.servicer_auth)) as joint
GROUP BY Driver_id
ORDER BY Total_income DESC, Total_order_completed DESC, Driver_id ASC;

/* 5. List of driver ID who took orders, but never complete an order. */
SELECT servicer_auth as Driver_id, (IFNULL(SUM(total_price), 0)) as Total_income, 
	(IF(IFNULL(SUM(total_price), 0)=0, 0, COUNT(servicer_auth))) as Total_order_completed
FROM
	(SELECT unique_driver.servicer_auth, total_price 
	FROM
		(SELECT DISTINCT servicer_auth FROM vaninterest) AS unique_driver
	LEFT JOIN
		(SELECT vaninterest.idvanOrder, vaninterest.servicer_auth, vanorder.total_price 
		FROM vaninterest 
		INNER JOIN vanorder ON vaninterest.servicer_auth = vanorder.servicer_auth
		WHERE vanorder.order_status = 2) as completed
	ON (unique_driver.servicer_auth = completed.servicer_auth)) as joint
GROUP BY Driver_id
HAVING Total_income = 0
ORDER BY Driver_id ASC;

/* Solution Reference: 
https://github.com/edwinytleung/MySQL/blob/master/Van_order_matching.sql */
