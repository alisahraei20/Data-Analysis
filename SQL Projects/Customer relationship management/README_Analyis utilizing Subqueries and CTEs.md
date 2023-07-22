# SQL Problem Solving with Subqueries and CTEs


This repository aims to solve a common SQL problem using two different methods, subqueries and Common Table Expressions (CTEs). It focuses on the `SalesOrderHeader` table in the AdventureWorks2019 database.


## Problem Statement
The task involves extracting and comparing the total sales due for the top 10 sales orders for each month, ranked by order amount. Two methods are used to accomplish this: subqueries and CTEs. The final output should be a list of the total sales due for each month, including the total sales due from the previous month for a comparison.


## Objective
The objective of this project is to leverage SQL's flexibility to perform complex data manipulations using two different methods - subqueries and CTEs. This would provide insights on:


1. How to extract valuable information from a database using SQL.
2. Compare and contrast the effectiveness, readability, and efficiency of subqueries and CTEs.
3. The top 10 sales orders for each month based on the `TotalDue` amount and the trend observed from month to month.
4. Understand the role that subqueries and CTEs can play in enhancing code maintainability and performance tuning in SQL.


By executing and analyzing these codes, you can understand which sales months had a significant increase or decrease compared to the previous month. This information can help the business focus its marketing efforts more efficiently.


## Steps to Run the Code


1. **Establish a Connection**: Connect to the AdventureWorks2019 database.


2. **Subqueries**:
    - Calculate the `ordermonth` and rank of each order in its respective month (`orderrank`) based on `TotalDue` for each order.
    - Filter for the top 10 orders each month.
    - Compute `top10total` which is the total of `TotalDue` for each month.
    - Self join this derived table on `ordermonth` offset by 1 month to get `top10total` for the previous month (`PrevToptentotal`).
    - Select `ordermonth`, `top10total`, and `PrevToptentotal`, then order the results by `ordermonth`.


3. **Common Table Expressions (CTEs)**:
    - Define a CTE (`sales`) that computes `ordermonth` and the rank of each order in its respective month (`orderrank`) based on `TotalDue`.
    - Define another CTE (`top10`) which filters for the top 10 orders each month and calculates `top10total`.
    - Join `top10` with itself on `ordermonth` offset by 1 month to compute `PrevToptentotal`.
    - Select `ordermonth`, `top10total`, and `PrevToptentotal`, then order the results by `ordermonth`.


4. **Comparison**:
    - Verify that the results from the subquery method and the CTE method align.
    - Analyze the readability and maintenance of both methods. Note that subqueries can be compact but difficult to read for complex queries, while CTEs break down complex queries into simpler parts, improving readability.
    - Assess the efficiency of both methods. The efficiency may vary based on the database system and the complexity of the query.


By completing these steps, you will understand the pros and cons of using subqueries and CTEs and can apply the best method to suit your use case. You can also derive insights on sales trends and performance over time, providing a valuable resource for business strategy and planning.

Output of the Code:

![WhatsApp Image 2023-07-22 at 10 42 17 PM](https://github.com/alisahraei20/Data-Analysis/assets/134171185/bcf96ee4-f89f-489a-b632-1bee014ea4b0)

#### DATASET FROM: https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms
