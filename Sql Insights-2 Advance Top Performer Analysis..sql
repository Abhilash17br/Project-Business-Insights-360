# Advance Top Performers. - Atliq Hardware.

--  REPORT FOR TOP MARKETS - BASED ON NET SALES.
--  REPORT FOR TOP PRODUCTS- BASED ON NET SALES.
--  REPORT FOR TOP CUSTOMERS-BASED ON NET SALES.

/*
- Profit and Loss Metrics.
Example -  Gross Price = $30
				- Pre-Invoice-Deductions = $2 (This is by Yearly agreement between Atliq an Customers)
		   Net Invoice Sales = Gross Price-Pre-Invoice-Deductions = (30-2) = $28
				- Post-Invoice-Deductions = $3 (Promotional Offer, Placement fee, Performance rebate)
           Net Sales = Net Invoice Sales - Post-Invoice-Deductions = (28-3) = $25
				- COGS(Cost on Goods Sold (Manufacturing Cost,Freight,Other Cost) = $20
		   Gross Margin = Net Sales - COGS = (25-20) = $5
           Gross Margin % = Gross Margin/Net Sales = 20%
             - Ads and Promotion $2
			Net Profit = Gross Margin - Ads and Promotion =(5-2) = $3
            Net profit % = Net Profit/Net Sales = 12%
*/


/*
-- PERFORMANCE IMPROVEMENT. FOR AN SQL QUERY..
-- Duration and Fetch are the two key metrics to understand performance of a query.
-- Duration is the time taken for a query to get executed.
-- Fetch is the time taken to retrieve the data from the database server.
-- EXPLAIN ANALYZE clause will help one to understand the query performance time.
*/

/*
WE ARE USING USED_FUNCTION 'GET_FISCAL_YEAR(S.DATE)' TO GET FISCAL YEAR , AND THIS IS BEING USED @
MULTIPLE PLACES, IT TAKE EVERY DATE ,THEN CONVERT TO FISCAL YEAR FOR SO MANY RECORDS, HENCE COULD BE REASON FOR TIME
SO, WE COULD CREATE A LOOK UP TABLE DIM_DATE, WITH FISCAL YEAR ACROSS VARIOUS DATES, WHICH COULD BE JOINED INITALLY
AND BE USED FOR JOINING OTHER CONDITIONS ON FISCAL YEAR..

TABLE CREATED WITH COLUMNS,CALENDAR DATE, AS IN SALES TABLE, FISCAL YEAR WILL BE AN GENIRIC COLUMN WITH LOGIC TO RETURN FISCAL_YEAR.
DATA COULD BE ADDED BY CREATING AN EXCEL FILE WITH CALENDAR_DATE COLUMN WITH DATA AS IN SALES TABLE, IE,
2018-09-01,2018-10-01,2018-11-01,,, TILL 2024., FISCAL_YEAR COLUMN AS EMPTY, AND SAVWE AS CSV..
THEN IMPORT CSV TO DIM_DATE TABLE ON MYSQL..
*/
SELECT * FROM DIM_DATE; # DONE CREATING TABLE ...

--  Addding Fiscal Year column in  Fact_sales_monthly table.-- to reduce Query time..

ALTER TABLE FACT_SALES_MONTHLY ADD COLUMN FISCAL_YEAR YEAR AFTER date;
SET SQL_SAFE_UPDATES = 0;
UPDATE FACT_SALES_MONTHLY SET FISCAL_YEAR = year((`DATE` + interval 4 month));

SELECT * FROM FACT_SALES_MONTHLY; --  ADDED FISCAL YEAR TO SALES_MONTHLY TABLE..

# -- QUERY UPDATED..
SELECT S.date,S.product_code,S.customer_code,C.customer,C.market,P.product,P.variant,S.sold_quantity,G.gross_price,
(G.gross_price*S.sold_quantity) AS gross_total_price,
PID.pre_invoice_discount_pct
FROM FACT_SALES_MONTHLY S
INNER JOIN DIM_CUSTOMER C ON C.customer_code = S.customer_code
INNER JOIN DIM_PRODUCT P ON P.product_code = S.product_code
INNER JOIN FACT_GROSS_PRICE G ON G.product_code = S.product_code AND G.fiscal_year = S.FISCAL_YEAR
INNER JOIN FACT_PRE_INVOICE_DEDUCTIONS PID ON PID.customer_code = S.customer_code AND PID.fiscal_year = S.FISCAL_YEAR
WHERE S.FISCAL_YEAR = 2021
LIMIT 10000000;

-- Concept of Views. There are so many metrics that are to be added to get the Required Results.
-- To add that many metrics we have to use so many CTE's which is difficult.

# Creating View-1 , with pre-invoice-discounts.
CREATE VIEW PRE_INVOICE_SALES AS
SELECT S.date,S.fiscal_year,S.product_code,S.customer_code,C.customer,C.market,C.region,
P.product,P.variant,S.sold_quantity,G.gross_price,
(G.gross_price*S.sold_quantity) AS gross_total_price,
PID.pre_invoice_discount_pct
FROM FACT_SALES_MONTHLY S
INNER JOIN DIM_CUSTOMER C ON C.customer_code = S.customer_code
INNER JOIN DIM_PRODUCT P ON P.product_code = S.product_code
INNER JOIN FACT_GROSS_PRICE G ON G.product_code = S.product_code AND G.fiscal_year = S.FISCAL_YEAR
INNER JOIN FACT_PRE_INVOICE_DEDUCTIONS PID ON PID.customer_code = S.customer_code AND PID.fiscal_year = S.FISCAL_YEAR;

SELECT * FROM PRE_INVOICE_SALES;

# Creating View-2 , with post_invoice_discount
CREATE VIEW POST_INVOICE_SALES AS 
SELECT PRE.*,(gross_total_price-gross_total_price*pre_invoice_discount_pct) AS net_invoice_sales,
		(POD.discounts_pct+POD.other_deductions_pct) AS post_invoice_discount_pct
FROM PRE_INVOICE_SALES PRE
INNER JOIN FACT_POST_INVOICE_DEDUCTIONS POD ON POD.customer_code = PRE.customer_code AND 
											POD.product_code = PRE.product_code AND POD.DATE = PRE.DATE;
                                           
SELECT * FROM POST_INVOICE_SALES;

# Creating View-3 , with Net_sales as final Metrics.
CREATE VIEW NET_SALES AS
SELECT *,(1-post_invoice_discount_pct)*NET_INVOICE_SALES as net_sales FROM POST_INVOICE_SALES;

SELECT * FROM NET_SALES; 

-- **********************************************************************************************************************************
# Problem Statement 1 - TOP MARKET.

-- FINDING TOP MARKET FOR ALL FISCAL_YEAR.
SELECT MARKET,FISCAL_YEAR,ROUND(SUM(NET_SALES),2) AS TOTAL_SALES
FROM NET_SALES 
GROUP BY MARKET,FISCAL_YEAR
ORDER BY TOTAL_SALES DESC;

-- FINDING TOP MARKETS BY USER SPECIFIED FINANCIAL_YEARS..
SELECT MARKET,ROUND(SUM(NET_SALES)/1000000,2) AS net_sales_mln
FROM NET_SALES
where FISCAL_YEAR = 2021
GROUP BY MARKET
ORDER BY net_sales_mln DESC;

-- Creating Stored Procedure to Automate the Process.
DELIMITER &&
CREATE PROCEDURE GET_TOP_N_MARKETS_BY_NET_SALES( IN_FISCAL_YEAR INT,IN_TOP_N INT)
BEGIN
	SELECT MARKET,ROUND(SUM(NET_SALES)/1000000,2) AS net_sales_mln
	FROM NET_SALES
	where FISCAL_YEAR = IN_FISCAL_YEAR
	GROUP BY MARKET
	ORDER BY net_sales_mln DESC
    LIMIT IN_TOP_N;
END &&

-- GET TOP 5 MARKET IN FY-2020
CALL GET_TOP_N_MARKETS_BY_NET_SALES(2020,5);

-- **********************************************************************************************************************************
# Problem Statement 2 - TOP CUSTOMERS.

-- FINDING TOP CUSTOMER BY USER SPECIFIED FINANCIAL_YEARS..
SELECT CUSTOMER,ROUND(SUM(NET_SALES)/1000000,2) AS net_sales_mln
FROM NET_SALES
where FISCAL_YEAR = 2021
GROUP BY CUSTOMER
ORDER BY net_sales_mln DESC;

-- Creating Stored Procedure to Automate the Process.
DELIMITER &&
CREATE PROCEDURE GET_TOP_N_CUSTOMERS_BY_NET_SALES( IN_FISCAL_YEAR INT,IN_TOP_N INT)
BEGIN
	SELECT CUSTOMER,ROUND(SUM(NET_SALES)/1000000,2) AS net_sales_mln
	FROM NET_SALES
	where FISCAL_YEAR = IN_FISCAL_YEAR
	GROUP BY CUSTOMER
	ORDER BY net_sales_mln DESC
    LIMIT IN_TOP_N;
END &&

CALL GET_TOP_N_CUSTOMERS_BY_NET_SALES(2020,5);

-- **********************************************************************************************************************************
# Problem Statement 3 - -- TO GET - TOP CUSTOMERS- BY MARKET,FISCAL YEAR ON NET_SALES.

-- Creating Stored Procedure to Automate the Process.
DELIMITER &&
CREATE PROCEDURE GET_TOP_N_CUSTOMERS_BY_MARKETS_BY_NET_SALES(IN_MARKET VARCHAR(50), IN_FISCAL_YEAR INT,IN_TOP_N INT)
BEGIN
	SELECT CUSTOMER,ROUND(SUM(NET_SALES)/1000000,2) AS net_sales_mln
	FROM NET_SALES
	where FISCAL_YEAR = IN_FISCAL_YEAR AND MARKET = IN_MARKET
	GROUP BY CUSTOMER
	ORDER BY net_sales_mln DESC
    LIMIT IN_TOP_N;
END &&

CALL GET_TOP_N_CUSTOMERS_BY_MARKETS_BY_NET_SALES("INDIA",2021,5);

-- **********************************************************************************************************************************
# Problem Statement 4 - -- TOP PRODUCTS.

-- FINDING TOP PRODUCTS BY USER SPECIFIED FINANCIAL_YEARS..
SELECT PRODUCT,ROUND(SUM(NET_SALES)/1000000,2) AS net_sales_mln
FROM NET_SALES
where FISCAL_YEAR = 2021
GROUP BY PRODUCT
ORDER BY net_sales_mln DESC;

-- Creating Stored Procedure to Automate the Process.
DELIMITER &&
CREATE PROCEDURE GET_TOP_N_PRODUCTS_BY_NET_SALES( IN_FISCAL_YEAR INT,IN_TOP_N INT)
BEGIN
	SELECT PRODUCT,ROUND(SUM(NET_SALES)/1000000,2) AS net_sales_mln
	FROM NET_SALES
	where FISCAL_YEAR = IN_FISCAL_YEAR
	GROUP BY PRODUCT
	ORDER BY net_sales_mln DESC
    LIMIT IN_TOP_N;
END &&

CALL GET_TOP_N_PRODUCTS_BY_NET_SALES(2020,5);

-- **********************************************************************************************************************************
# Problem Statement 5
-- Description
-- As a product owner, I want to see a bar chart report for FY=2021 for top 10 CUSTOMERS GLOBALLY by % net sales.

WITH CTE AS (
SELECT CUSTOMER,ROUND(SUM(NET_SALES)/1000000,2) AS net_sales_mln
FROM NET_SALES
where FISCAL_YEAR = 2021
GROUP BY CUSTOMER
ORDER BY net_sales_mln DESC)
SELECT CUSTOMER,net_sales_mln*100/SUM(net_sales_mln) OVER() AS net_sales_pct
FROM CTE limit 10;

-- **********************************************************************************************************************************
# Problem Statement 6 -- Net sales % share by region
/*
Description
As a product owner, I want to see region wise (APAC, EU, LTAM etc) % net sales 
breakdown by customers in a respective region so that I can perform my regional analysis on 
financial performance of the company.
The end result should be PIE charts for FY-2021.
Build a reusable asset that we can use to conduct this analysis for any financial year.
*/
WITH CTE AS(
SELECT CUSTOMER,FISCAL_YEAR,REGION,ROUND(SUM(NET_SALES)/1000000,2) AS net_sales_mln
FROM NET_SALES
GROUP BY CUSTOMER, FISCAL_YEAR, REGION)
SELECT FISCAL_YEAR,region,CUSTOMER, net_sales_mln*100/SUM(net_sales_mln) OVER(partition by fiscal_year,region) AS net_sale_pct
from cte;
-- WE EXPORT EXCEL, AND THEN WE PLOT...BY DIFF YEAR AND REGION...

-- **********************************************************************************************************************************
# Problem Statement 7 -- Top N Products in Each Division by their Quantity Sold, for an given fiscal year.
WITH CTE1 AS(
			WITH CTE AS(
						SELECT division,product,SUM(sold_quantity) AS TOTAL_QTY
						FROM FACT_SALES_MONTHLY
						INNER JOIN DIM_PRODUCT USING(product_code)
						where FISCAL_YEAR = 2018
						GROUP BY DIVISION,PRODUCT
						ORDER BY TOTAL_QTY DESC)
			SELECT *,ROW_NUMBER() OVER(PARTITION BY DIVISION ORDER BY TOTAL_QTY DESC) AS RN FROM CTE)
SELECT * FROM CTE1 WHERE RN<=3
ORDER BY DIVISION;

# STORED PROCEDURE FOR THE SAME..
DELIMITER &&
CREATE PROCEDURE TOP_N_PRODUCT_BY_QTY(IN IN_DIVISION VARCHAR(50),IN IN_FISCAL_YEAR INT, IN IN_NUM INT)
BEGIN
	WITH CTE1 AS(
	WITH CTE AS(
	SELECT division,product,FISCAL_YEAR,SUM(sold_quantity) AS TOTAL_QTY
	FROM FACT_SALES_MONTHLY
	INNER JOIN DIM_PRODUCT USING(product_code)
	GROUP BY DIVISION,PRODUCT,FISCAL_YEAR
	ORDER BY TOTAL_QTY DESC)
	SELECT *,DENSE_RANK() OVER(PARTITION BY FISCAL_YEAR,DIVISION ORDER BY TOTAL_QTY DESC) AS DNRK FROM CTE) 
	SELECT * FROM CTE1 
    WHERE DIVISION = IN_DIVISION AND FISCAL_YEAR = IN_FISCAL_YEAR AND  DNRK <= IN_NUM ;
END &&

CALL TOP_N_PRODUCT_BY_QTY('P & A',2020,3);

-- **********************************************************************************************************************************
# Problem Statement 8 
-- Exercise: -- Retrieve the top 2 markets in every region by their gross sales amount in FY=2021. 

WITH CTE1 AS(
			WITH CTE AS(
						SELECT C.market,C.region,S.sold_quantity,G.gross_price,
                        ROUND(SUM(S.sold_quantity*G.gross_price)/1000000,2) AS gross_sales_mln
						FROM FACT_SALES_MONTHLY S
						INNER JOIN DIM_CUSTOMER C USING(customer_code)
						INNER JOIN FACT_GROSS_PRICE G USING(product_code,fiscal_year)
						WHERE S.FISCAL_YEAR = 2021
						GROUP BY C.market,C.region
						LIMIT 10000000)
			SELECT *, DENSE_RANK() OVER(PARTITION BY REGION ORDER BY gross_sales_mln DESC) as DNRK FROM CTE)
SELECT region,market,gross_sales_mln 
FROM CTE1 
WHERE DNRK<=2  
ORDER BY region;


-- **********************************************************************************************************************************