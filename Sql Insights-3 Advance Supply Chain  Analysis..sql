# Advance Advance Supply Chain. - Atliq Hardware.

-- **********************************************************************************************************************************
# Problem Statement 1
/*
Forecast Accuracy for all customers for a given fiscal year
Description : As a product owner, I need an aggregate forecast accuracy report for all the customers for a given 
fiscal year so that I can track the accuracy of the forecast we make for these customers.
The report should have the following fields,
1. Customer Code, Name, Market
2. Total Sold Quantity
3. Total Forecast Quantity
4. Net Error
5. Absolute Error
6. Forecast Accuracy%
*/

-- "Create a Helper Table T	o Help With Query.."

CREATE TABLE FACT_ACT_EST
(
SELECT S.date,S.fiscal_year,S.product_code,S.customer_code,S.sold_quantity,F.forecast_quantity
FROM FACT_SALES_MONTHLY S
LEFT OUTER JOIN FACT_FORECAST_MONTHLY F USING(product_code,customer_code,date)
UNION
SELECT F.date,F.fiscal_year,F.product_code,F.customer_code,S.sold_quantity,F.forecast_quantity
FROM FACT_FORECAST_MONTHLY F
LEFT OUTER JOIN FACT_SALES_MONTHLY S USING(product_code,customer_code,date)
);

SELECT * FROM FACT_ACT_EST;

# DATA CLEANING AND ALTERING TABLE..

-- Modifying Table to Create Composite Key, based on Date,Product_code,Customer_code.
ALTER TABLE FACT_ACT_EST ADD CONSTRAINT TEST PRIMARY KEY(DATE,product_code,customer_code);

ALTER TABLE FACT_ACT_EST DROP COLUMN FISCAL_YEAR; -- dropping existing fiscal year

ALTER TABLE FACT_ACT_EST ADD COLUMN fiscal_year YEAR AFTER DATE;
SET SQL_SAFE_UPDATES = 0;
UPDATE FACT_ACT_EST SET fiscal_year = YEAR(DATE_ADD(DATE,INTERVAL 4 MONTH));

-- REPLACE ALL NULLS WITH 0, FROM SOLD, FORECAST QTY..
UPDATE FACT_ACT_EST SET sold_quantity = 0 WHERE sold_quantity IS NULL;
UPDATE FACT_ACT_EST SET forecast_quantity = 0 WHERE forecast_quantity IS NULL;
SELECT * FROM FACT_ACT_EST;

# TRIGGERS TO AUTOMATE RECORD INSERTION INTO FACT_ACT_EST TABLE.

-- TRIGGER FOR RECORDS TO BE INSERTED INTO "FACT_ACT_EST" AS AND WHEN RECORDS ARE ADDED TO 'FACT_SLAES_MONTHLY'
DELIMITER //
CREATE TRIGGER FACT_SALES_MONTHLY_AFTER_INSERT
AFTER INSERT
ON FACT_SALES_MONTHLY FOR EACH ROW
BEGIN
	INSERT INTO FACT_ACT_EST(date,product_code,customer_code,sold_quantity) 
    VALUES(NEW.date,NEW.product_code,NEW.customer_code,NEW.sold_quantity)
    ON DUPLICATE KEY 
    UPDATE sold_quantity = values(sold_quantity);
END; //

-- TRIGGER FOR RECORDS TO BE INSERTED INTO "FACT_ACT_EST" AS AND WHEN RECORDS ARE ADDED TO 'FACT_FORECAST_MONTHLY'
DELIMITER //
CREATE TRIGGER FACT_FORECAST_MONTHLY_AFTER_INSERT
AFTER INSERT
ON FACT_FORECAST_MONTHLY FOR EACH ROW
BEGIN
	INSERT INTO FACT_ACT_EST(date,product_code,customer_code,forecast_quantity) 
    VALUES(NEW.date,NEW.product_code,NEW.customer_code,NEW.forecast_quantity)
    ON DUPLICATE KEY 
    UPDATE forecast_quantity = values(forecast_quantity);
END; //

-- FINAL QUERY
WITH CTE AS(
			SELECT F.customer_code,C.customer,C.market,
			sum(sold_quantity) AS total_sold_qty,sum(forecast_quantity) as total_forecast_qty,
			sum((forecast_quantity-sold_quantity)) AS net_error,
			sum((forecast_quantity-sold_quantity))*100/sum(forecast_quantity) AS net_error_pct,
			sum(abs(forecast_quantity-sold_quantity)) AS abs_error,
			sum(abs(forecast_quantity-sold_quantity))*100/sum(forecast_quantity) AS abs_error_pct
			FROM FACT_ACT_EST F
			INNER JOIN DIM_CUSTOMER C USING(customer_code)
			WHERE FISCAL_YEAR = 2021
			GROUP BY customer_code,MARKET)
SELECT *,IF((100-abs_error_pct)>=0,(100-abs_error_pct),0) AS forecast_accuracy
FROM CTE
ORDER BY forecast_accuracy DESC;

# STORED PROCEDURE FOR THE SAME..
DELIMITER &&
CREATE PROCEDURE GET_FORECAST_ACCURACY(IN IN_FISCAL_YEAR INT)
BEGIN
	WITH CTE AS(
				SELECT F.customer_code,C.customer,C.market,
				sum(sold_quantity) AS total_sold_qty,sum(forecast_quantity) as total_forecast_qty,
				sum((forecast_quantity-sold_quantity)) AS net_error,
				sum((forecast_quantity-sold_quantity))*100/sum(forecast_quantity) AS net_error_pct,
				sum(abs(forecast_quantity-sold_quantity)) AS abs_error,
				sum(abs(forecast_quantity-sold_quantity))*100/sum(forecast_quantity) AS abs_error_pct
				FROM FACT_ACT_EST F
				INNER JOIN DIM_CUSTOMER C USING(customer_code)
				WHERE FISCAL_YEAR = IN_FISCAL_YEAR
				GROUP BY customer_code,MARKET)
	 SELECT *,IF((100-abs_error_pct)>=0,(100-abs_error_pct),0) AS forecast_accuracy
	 FROM CTE
	 ORDER BY forecast_accuracy DESC;
END &&

CALL GET_FORECAST_ACCURACY(2021);

-- **********************************************************************************************************************************
# Problem Statement 2
-- SELECT ALL RECORDS WHERE FORECAST_ACCURACY FOR 2020>2021.

CREATE TEMPORARY TABLE FORECAST_ERR_TABLE_2021
WITH CTE AS(
SELECT F.customer_code,C.customer,C.market,
sum(sold_quantity) AS total_sold_qty,sum(forecast_quantity) as total_forecast_qty,
sum((forecast_quantity-sold_quantity)) AS net_error,
sum((forecast_quantity-sold_quantity))*100/sum(forecast_quantity) AS net_error_pct,
sum(abs(forecast_quantity-sold_quantity)) AS abs_error,
sum(abs(forecast_quantity-sold_quantity))*100/sum(forecast_quantity) AS abs_error_pct
FROM FACT_ACT_EST F
INNER JOIN DIM_CUSTOMER C USING(customer_code)
WHERE FISCAL_YEAR = 2021
GROUP BY customer_code,MARKET)
SELECT *,IF((100-abs_error_pct)>=0,(100-abs_error_pct),0) AS forecast_accuracy
FROM CTE
ORDER BY forecast_accuracy DESC;

CREATE TEMPORARY TABLE FORECAST_ERR_TABLE_2020
WITH CTE AS(
SELECT F.customer_code,C.customer,C.market,
sum(sold_quantity) AS total_sold_qty,sum(forecast_quantity) as total_forecast_qty,
sum((forecast_quantity-sold_quantity)) AS net_error,
sum((forecast_quantity-sold_quantity))*100/sum(forecast_quantity) AS net_error_pct,
sum(abs(forecast_quantity-sold_quantity)) AS abs_error,
sum(abs(forecast_quantity-sold_quantity))*100/sum(forecast_quantity) AS abs_error_pct
FROM FACT_ACT_EST F
INNER JOIN DIM_CUSTOMER C USING(customer_code)
WHERE FISCAL_YEAR = 2020
GROUP BY customer_code,MARKET)
SELECT *,IF((100-abs_error_pct)>=0,(100-abs_error_pct),0) AS forecast_accuracy
FROM CTE
ORDER BY forecast_accuracy DESC;

SELECT F0.customer_code,F0.customer,F0.market,F0.forecast_accuracy,F1.forecast_accuracy
FROM FORECAST_ERR_TABLE_2020 F0
INNER JOIN FORECAST_ERR_TABLE_2021 F1
WHERE F0.forecast_accuracy > F1.forecast_accuracy;

-- **********************************************************************************************************************************
