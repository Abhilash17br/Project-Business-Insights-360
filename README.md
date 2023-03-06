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
* Analyzed sales data of a hardware manufacturing company and generated insights related to finance, sales, market, and supply chain analytics.  Used statistical functions for data aggregation and summarization to generate Profit and Loss metrics. Developed Stored Procedures to help managers derive insights.
●	Generated valuable reports to stakeholders on top markets, platforms, and customers. Metrics, such as Net Error, Absolute Net Error, and Forecast Accuracy, that helped businesses make informed decisions.
●	Connected Power BI to MySQL and Excel, transformed data by establishing a data pipeline (ETL) using Power Query, Data Modelling to establish relations by snowflake schema and initial Data validation was done against benchmark values.
●	Utilized DAX to create calculated columns and measures, and built a dynamic dashboard with KPI’s for sales, finance, marketing, and supply chain.
●	Published a report on Power BI service for user acceptance testing (UAT) and Data validation through Excel Analyze.
●	Incorporated stakeholder feedback to create an Executive Dashboard, resolved quality issues, optimized dashboard performance, and deployed the dashboard to Power BI service with gateway setup to MySQL Database and local Excel files for Automatic Data Refresh. 
●	Various Project Management Skills like Project charter, stakeholder mapping analysis, Kanban board for task assignment to improve productivity
●	A Designed dashboard with up to three levels of analysis, was able to ask the stakeholders many why’s, to their top performing, product, markets, customers, % changes and trends in P&L metrics, supply chain forecast accuracy for inventory management has helped to improve overall business.
*



## Key Insights:

*Checking at weekday, Weekend Table For ADR, RevPAR,Occupancy%,we could conclude that overall hotels are not changing the price between weedays and weekends.
There is an Potential Oppurtunity to generate income, by changing Price between weekday and weekends, which most of the hotels have not adopted.*

*The Fluctuation in ADR remains same over the time which is directly proportional to pricing ,Occupancy % is seen increasing Marginally,Revpar varies in linear with Occupancy % . This shows that the revenue growth over time is only due to its increase in occupancy %, and price for most of the hotels over time is almost constant, this could be an oppturnity to increase revenue through pricing*

*occupancy %  is directly proportional to Average Ratings of the Hotel, and inversely Proportional with Pricing. Hotels with less Occupancy should work on its Ratings.*

*Relization provides the details of conversion rates form booking to checkin, if the relization is low,it could be that customer is not pleased with apperance of the hotel as when compared to bokking it online.*


# Thank you.
