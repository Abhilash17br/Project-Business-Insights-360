# Advance Finance Analytics. - Atliq Hardware.

-- Requests form Product owners..
-- ********************************************************************************************************************************************************
# Request 1.
/*
- CROMA INDIA PRODUCT WISE SALES REPORT FOR FISCAL YEAR 2021..
As a product owner, I want to generate a report of individual product sales (aggregated on a monthly basis at the product code level)
for Croma India customer for FY-2021 so that I can track individual product sales and run further product analytics on it in excel.
The report should have the following fields,
1. Month
2. Product Name
3. Variant
4. Sold Quantity
5. Gross Price Per Item
6. Gross Price Total

-- MONTH.
-- PRODUCT NAME.
-- VARIANT.
-- SOLD QUANTITY.
-- GROSS PRICE PER ITEM.
-- GROSS PRICE TOTAL.
*/

SELECT S.DATE,S.product_code,P.product,P.variant,S.sold_quantity,
			  G.gross_price,round(G.gross_price*S.sold_quantity,2) AS gross_price_total
 FROM FACT_SALES_MONTHLY S
 LEFT JOIN DIM_PRODUCT P  ON P.product_code = S.product_code
 LEFT JOIN FACT_GROSS_PRICE G ON G.product_code = S.product_code AND 
                                 G.fiscal_year = year(date_add(S.date, interval 4 month))
 WHERE S.customer_code IN (SELECT CUSTOMER_CODE FROM DIM_CUSTOMER WHERE customer LIKE"%CROMA%" AND MARKET  = "INDIA") and 
       year(date_add(S.date, interval 4 month)) = 2021
 ORDER BY DATE ASC
 limit 1000000;

--  year(date_add(date, interval 4 month )) - this is a long query, and since most of the problems are based on fiscal year...
--  we could create a function to get fiscal year..

# Function to get Fiscal year from date.- atliq has fiscal year starting from sept month , so 2020 sept is the begining of 2021 fiscal year.
delimiter $$
create function get_fiscal_year(calendar_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE fiscal_year INT;
    SET fiscal_year = year(date_add(calendar_date, interval 4 month ));
    return fiscal_year;
end $$

-- Checking fisacl year function.
select get_fiscal_year('2017-10-01');

-- Final Query... 
SELECT S.DATE,S.product_code,P.product,P.variant,S.sold_quantity,G.gross_price,round(G.gross_price*S.sold_quantity,2) AS gross_price_total
FROM FACT_SALES_MONTHLY S
LEFT JOIN DIM_PRODUCT P  ON P.product_code = S.product_code
LEFT JOIN FACT_GROSS_PRICE G ON G.product_code = S.product_code AND G.fiscal_year = get_fiscal_year(S.date)
WHERE S.customer_code IN (SELECT CUSTOMER_CODE FROM DIM_CUSTOMER WHERE customer LIKE"%CROMA%" AND MARKET  = "INDIA") and 
get_fiscal_year(S.date) = 2021
ORDER BY DATE ASC
limit 1000000;

-- ********************************************************************************************************************************************************
# Request 2.
/*
Description
As a product owner, I need an aggregate monthly gross sales report for 'Croma India' customer so that I can track 
how much sales this particular customer is generating for AtliQ and manage our relationships accordingly.
The report should have the following fields,
1. Month
2. Total gross sales amount to Croma India in this month.
********************************************************
-- TASK OVERVIEW..
-- WE NEED AN MONTHLY GROSS_PRICE  OF CROMA_INDIA..
*/

-- Final Query....
SELECT S.date, round(sum(S.sold_quantity*G.gross_price),2) AS gross_total_price
FROM FACT_SALES_MONTHLY S
INNER JOIN FACT_GROSS_PRICE G ON G.product_code = S.product_code AND G.fiscal_year = GET_FISCAL_YEAR(S.date)
WHERE customer_code IN (SELECT CUSTOMER_CODE FROM DIM_CUSTOMER WHERE customer LIKE"%CROMA%" AND MARKET  = "INDIA")
GROUP BY S.date
ORDER BY S.date;

-- ********************************************************************************************************************************************************
# Request 3.
/*
Exercise: Yearly Sales Report
Generate a yearly report for Croma India where there are two columns
1. Fiscal Year
2. Total Gross Sales amount In that year from Croma
*/

SELECT GET_FISCAL_YEAR(S.date) as fiscal_year,round(sum(S.sold_quantity*G.gross_price),2) AS gross_total_price
FROM FACT_SALES_MONTHLY S
INNER JOIN FACT_GROSS_PRICE G ON G.product_code = S.product_code AND G.fiscal_year = GET_FISCAL_YEAR(S.date)
WHERE customer_code IN (SELECT CUSTOMER_CODE FROM DIM_CUSTOMER WHERE customer LIKE"%CROMA%" AND MARKET  = "INDIA")
GROUP BY fiscal_year
ORDER BY S.date;

-- ********************************************************************************************************************************************************
# Request 4.
# STORED PROCEDURE - TO AUTOMATE TASKS.
-- IT IS A WAY TO AUTOMATE REPEATED TASKS SUCH AS CREATING SAME REPORT FOR DIFFERENT CUSTOMERS..

# STORED PROCEDURE FOR -- GROSS_SALES MONTHLY..
DELIMITER &&
CREATE PROCEDURE GROSS_SALES_MONTHLY_FINAL(CUSTOMER_NAME VARCHAR(50), LOC VARCHAR(50))
BEGIN
	SELECT S.date, round(sum(S.sold_quantity*G.gross_price),2) AS gross_total_price
		FROM FACT_SALES_MONTHLY S
		INNER JOIN FACT_GROSS_PRICE G ON G.product_code = S.product_code AND G.fiscal_year = GET_FISCAL_YEAR(S.date)
		WHERE CUSTOMER_CODE IN (SELECT CUSTOMER_CODE FROM DIM_CUSTOMER WHERE CUSTOMER =CUSTOMER_NAME  AND MARKET = LOC)
		GROUP BY S.date
		ORDER BY S.date;
END &&

-- Validating stored Procedure.
CALL GROSS_SALES_MONTHLY_FINAL('AMAZON','INDIA');

-- ********************************************************************************************************************************************************
# Request 5.
/*
Description
Create a stored proc that can determine the market badge based on the following logic,
If TOTAL_GROSS_PRICE > 5 million that market is considered Gold else it is Silver

My input will be,
market
fiscal year
Output
market badge
*/

-- Query for the same...
SELECT CASE
			WHEN SUM(S.sold_quantity*G.gross_price) > 5000000 THEN "GOLD"
            ELSE "SILVER"
            END AS MARKET_BADGE
FROM  FACT_SALES_MONTHLY S
INNER JOIN DIM_CUSTOMER C ON C.customer_code = S.customer_code
INNER JOIN FACT_GROSS_PRICE G ON G.product_code = S.product_code AND G.fiscal_year = GET_FISCAL_YEAR(S.DATE)
WHERE MARKET = "INDIA" AND FISCAL_YEAR = 2021
GROUP BY GET_FISCAL_YEAR(S.DATE);

-- STORED PROCEDURE.
DELIMITER &&
CREATE PROCEDURE MARKET_BADGE1(LOC VARCHAR(50),FIS_YEAR INT)
BEGIN
SELECT CASE
			WHEN SUM(S.sold_quantity*G.gross_price) > 5000000 THEN "GOLD"
            ELSE "SILVER"
            END AS MARKET_BADGE
FROM  FACT_SALES_MONTHLY S
INNER JOIN DIM_CUSTOMER C ON C.customer_code = S.customer_code
INNER JOIN FACT_GROSS_PRICE G ON G.product_code = S.product_code AND G.fiscal_year = GET_FISCAL_YEAR(S.DATE)
WHERE MARKET = LOC AND FISCAL_YEAR = FIS_YEAR
GROUP BY GET_FISCAL_YEAR(S.DATE);
END &&

CALL MARKET_BADGE1('CHINA',2020);

/*
- BENEFITS OF STORED PROCEDURE..
1.CONVENINENCE- IT CAN BE USED BY BUSINESS OWNERS OR MANAGERS AS AN USER TO RETRIVE DATA...
2.SECURITY -  CAN GIVE LIMITED TO ACCESS TO USERS ONLY ON STORED PROCEDURE, SO ONE WITH ACCESS CAN ACCESS STORED PROCEDURE ONLY VIA STORED PROCEDURE, AND NOT ALTER DATASET..
3.A STORED PROCEDURE CAN BE RUN VIA PYTHON TO RETRIVE INFORMATION  AND WORK ON IT.
  IF NOT FOR STORED PROCEDURE , AN ENTIRE SQL QUERY HAS TO BE WRITTEN IN PYTHON..
4.MAINTAINABILITY.. - WE CAN UPDATE ANY PROCEDURE AT OUR CONVENCENE, AND EASY MAINTAINANCE..
5.PERFORMANCE..HIGH PERFORMANCE.
6.DEVELOPER PRODUCTIVITY..
*/