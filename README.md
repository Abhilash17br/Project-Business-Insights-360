# Project-Business-Insights-360 (Data Analyst Challenge at Codebasics.io)
## SQL Data Exploration & Power BI Dashboard.

## Link to my Dashboard
🔷Novypro Dashboard - https://www.novypro.com/project/business-insights-360-4

🔷Power BI Service  - https://app.powerbi.com/reportEmbed?reportId=4fa34d70-3e56-45cc-bc68-a1ba47ec354c&autoAuth=true&ctid=5583c874-04ed-477b-8448-d0b72a6e40e2

## Overview:
*Project: Provide Insights on Finance,sales,Marketing,Supply Chain to the Management.*
*Domain: Manufacturing Domain*

*AtliQ Hardware is a company that Sells and Manufactures Hardware.They have Customers all over the world and Products under various categories.
AtliQ Team use MS excel for data analysis but as the business expands globally company's Top management decides to use Power BI for data analytics.
So Top management wanted the analytics team to Provide insights through SQl to make decisions and as later part of the Project a dashboard to be created for various key departments, so they can get insights on  important metrics and make data driven Decisions*


 ## Task:

*As an data analyst who has been provided with sample data and a mock-up dashboard to work on the following task.*

* Write Sql Queries to Generate important insights and reports for product owners to make an data driven decisions.*

* Create Stored Procedures so that managers can extract the reports based on the filters.*

* Create an fully functional Dashbord for Data Driven Decisiosn, which gives insights on various departments like Finance, sales, marketing, Supply chain.*


## Tech stack used in the project:

* MySQL*
* MS Excel*
* Power BI*

## Work Flow:
### SQL Workbench

* Data was Loading into Mysql and database was designed by establishing relationships in a Snowflake schema format between the tables with ERD in MySQL.*
* Data was ready for Data Analysis and key metrics were Derived, for all the requests from Product owners*
* Stored Procedures were created for the comples Queries so that Product owners can extract  reports by necessary filters*
* An Data pipeline was established in deriving Metrics, with many Data Cleaning methods implemented in between.
* Reports were generated for [Profit and loss Metrics](https://github.com/Abhilash17br/Project-Business-Insights-360/blob/main/Sql%20Insights-1%20Advance%20Finance%20Analysis..sql), [Deriving Top Metrics](https://github.com/Abhilash17br/Project-Business-Insights-360/blob/main/Sql%20Insights-2%20Advance%20Top%20Performer%20Analysis..sql), and Procedures to track [Forecast Accuracy for Supply Chain Department](https://github.com/Abhilash17br/Project-Business-Insights-360/blob/main/Sql%20Insights-3%20Advance%20Supply%20Chain%20%20Analysis..sql).

### PowerBI Dashboard

* Connected Power BI to MySQL and Excel, transformed data by establishing a data pipeline (ETL) using Power Query, Data Modelling to establish relations by snowflake schema and initial Data validation was done against benchmark values.*
* Utilized DAX to create calculated columns and measures, and built a dynamic dashboard with KPI’s for sales, finance, marketing, and supply chain.*
* Published a report on Power BI service for user acceptance testing (UAT) and Data validation through Excel Analyze.*
* Incorporated stakeholder feedback to create an Executive Dashboard, resolved quality issues, optimized dashboard performance, and deployed the dashboard to Power BI service with gateway setup to MySQL Database and local Excel files for Automatic Data Refresh.*
* Various Project Management Skills like Project charter, stakeholder mapping analysis, Kanban board for task assignment to improve productivity.*
* A Designed dashboard with up to three levels of analysis, was able to ask the stakeholders many why’s, to their top performing, product, markets, customers, % changes and trends in P&L metrics, supply chain forecast accuracy for inventory management has helped to improve overall business.*
* Created intuitive dashboards(Views), specifically targeted to various departments to give an overview of the company's performance.*
✔ Finance View
✔ Sales View
✔ Marketing View
✔ Supply Chain View
✔ Executive View

## Key Features in Finance View:
* Profit & Loss Statement in Detail (P & L Statement).*
* KPI’s for Net Sales, Gross Margin %, Net Profit %.*
* Sales Target vs Actual Sales analysis*
* Analysis for Running Year vs Last Year*
* Top / Bottom Product and Top / Bottom Customers based on Net Sales*
* Performance Over Time in both Selected Year and Benchmark (Benchmark = Last Year & Target)*

## Key Features in Sales View:
* Unit Economics 1: Net Sales vs Total Post Invoice Discount Amount and Pre-Invoice Discount Amount given by the Company*
* Unit Economics 2: Total Cost of Goods Sold (COGS) spent by the Company and then finally got the actual Gross Margin*
* Customer and Product Performance analysis based on Net Sales, Gross Margin and Gross Margin %*
* Performance Matrix analysis for Market, Customer and Region based on Net Sales and Gross Margin %*
* Sales Trend Tooltip for every single Customer based on Net Sales and Gross Margin %*

## Key Features in Marketing View:
* Unit Economics: There are some Operational Expenses spent for Product. After subtracting this Expenses got the actual scenario of Net Profit*
* Performance Matrix analysis for Segment, Category and Product based on both “Net Sales & Net Profit %” and “Net Sales & Gross Margin %” by using a dynamic toggle button*

## Key Features in Supply Chain View:
* KPI’s for Forecast Accuracy, Net Error, ABS Error*
* Risk Factor analysis*
* Accuracy vs Net Error Trend analysis*
* Key Metrics for both Customer and Products based on FA%, FA% LY, Net Error, Net Error%, Risk Factor*

Executive View:
Report Page for the Top Level Management of the Company who want to check on all key metrics and KPI's.
* Market Share Trend analysis for AtliQ and other competitors*
* Revenue analysis by Division and Channel*
* Top 5 Products and Top 5 Customers by Revenue*
* Key Insights by Sub Zone with Revenue Contribution % analysis*



The most helpful measures for senior management are the Gross Margin and Net Profit (Gross Margin - Operational Costs).
View of building sales
Gross Margin and Net Sales (Revenue) are more significant to the sales team than Net Profit since, in most cases, they have little to no control over operating costs.
Building Marketing Perspective:
Understanding the changes in marketing spend over time and how those changes affect revenue and gross margin is crucial for the marketing team.
Chain of Supply in Construction:
Forecast Accuracy & Risk (Out of Stock or Excess Inventory) and Net Error & Absolute Error are crucial KPIs for the supply chain team.
Executive Perspective of the Building:
1. One of the most helpful abilities that aids in the creation of insightful visuals is the managing of stakeholder expectations.
2. During our feedback session, the executives instructed me to create a table outlining the key insights for each zone along with the associated risk.
In order to stay in touch with the Executives and receive their input on the Visualizations, information and help pages were also established.

# Thank you.
