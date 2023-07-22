# Customer Spending and Buying Frequency Analysis

## Problem Statement
The current structure of our `#CustomerProfiles` table does not provide a categorization based on customers' spending and buying frequency patterns. This lack of categorization hinders our ability to quickly analyze customer behavior, formulate strategic marketing campaigns, and tailor our products to cater to specific customer groups. In addition, we are missing out on insights that could inform us about the most popular products among different customer categories.

## Objectives

### 1. Extend Customer Profiles with Spending and Buying Frequency Categories
The goal is to add two new categories to our `#CustomerProfiles` table: `SpendingCategory` and `BuyingFrequencyCategory`. These categories should be populated based on the total amount spent and the number of orders by each customer, allowing us to classify customers into groups such as 'High spender', 'Medium spender', 'Low spender', 'Frequent buyer', 'Regular buyer', and 'Infrequent buyer'.

### 2. Analyze Aggregated Customer Behavior
We aim to generate insights about average spending, average order frequency, the number of high spenders, and the number of frequent buyers in our customer base. This analysis will provide a high-level overview of our customer behavior.

### 3. Identify Popular Products Among High Spenders and Frequent Buyers
We want to discover the most popular products among 'High spenders' and 'Frequent buyers'. By understanding the preferences of these significant customer segments, we can tailor our offerings and marketing efforts more effectively.

## Step-by-Step Process

### 1. Extend Customer Profiles Table
Start by altering the `#CustomerProfiles` table to add the `SpendingCategory` and `BuyingFrequencyCategory` fields. Populate these new fields with the corresponding categories based on the total spent and the number of orders by each customer.

### 2. Aggregate Analysis of Customer Behavior
Next, calculate the average spending and order frequency across all customers. Additionally, count the number of 'High spenders' and 'Frequent buyers' to understand the proportion of these key customer segments in the total customer base.

### 3. Identify Popular Products Among High Spenders
Run a query to identify the most popular products among 'High spenders'. Group the data by the most purchased product and sort it in descending order to find out which products are most preferred by high spenders.

### 4. Identify Popular Products Among Frequent Buyers
Lastly, perform a similar operation to identify the most popular products among 'Frequent buyers'. Again, group the data by the most purchased product and sort it in descending order to understand which products are most sought after by frequent buyers.

Output of the Code:
![WhatsApp Image 2023-07-22 at 11 05 27 PM](https://github.com/alisahraei20/Data-Analysis/assets/134171185/c5aba900-d4fc-4e42-8cbd-b345bf0147f4)

#### DATASET FROM: https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms
