
# Customer Data Analysis

## Problem Statement
Our current customer database lacks geographical details in the customer profiles, which hinders our ability to perform granular analyses based on location-specific factors such as countries, states, and cities. Furthermore, we need to conduct an in-depth analysis to understand customer behavior and preferences better, which can help us devise more effective marketing and sales strategies. In addition, monitoring spending trends and providing additional insights about top buyers in each state will enable us to serve these customers more efficiently and strategically.

## Objectives

### 1. Augment Customer Profiles with Geographical Information
We aim to enhance the `#CustomerProfiles` table with geographical information, including country, state, and city data. This information will be extracted from related tables in our database and associated with the corresponding customer profiles. This will enable more granular, location-based analyses.

### 2. Identify Top Buyers in Each State
Our objective is to rank customers in each state based on their total expenditure, which will allow us to identify the top buyers. This understanding can help us comprehend the distribution and spending patterns of our customer base.

### 3. Determine Preferred Product Categories per State
We want to ascertain the preferred product category for customers in each state. This knowledge can help our company optimize its product offerings based on geographical preferences, potentially leading to increased customer satisfaction and sales.


### 4. Provide Additional Insights About Top Buyers in Each State
We aim to offer comprehensive insights about the top buyers in each state. This includes:

- **Preferred product**: Understanding the most frequently purchased product by each top buyer.
- **Total orders**: Knowing the number of orders placed by each top buyer.
- **Most active day**: Identifying the day of the week when each top buyer is most likely to place an order.
- **Email promotion preference**: Learning whether each top buyer prefers receiving promotions via email.

This in-depth analysis will enable our company to serve these top customers more effectively, fostering customer loyalty, and potentially boosting our sales.



— step by step

# Customer Analysis Process

## Overview
The following steps provide a detailed breakdown of the process we use to analyze our customers' geographical distribution, spending habits, and product preferences. This information helps us refine our marketing and sales strategies, and better cater to our customers' needs.

## Process

### 1. Add Geographical Information to Customer Profiles
First, we update our customer profiles by adding geographical information to each profile. This includes data such as the country, state, and city of each customer. This step involves altering the #CustomerProfiles table and populating the new fields with the correct information from associated tables.

### 2. Identify Top Buyers in Each State
Next, we rank customers in each state based on their total spending. This helps us identify the top three buyers in each state. We utilize a common table expression (CTE) to achieve this ranking.

### 3. Determine Preferred Product Category Per State
We then join our updated #CustomerProfiles table with a subquery, which obtains the most purchased product category for each customer. This allows us to identify the preferred product category for customers in each state. This information is obtained by joining and querying various tables related to sales and product details.

### 4. Gather Additional Insights About Top Buyers in Each State
Finally, we aim to provide additional insights about the top buyers in each state. This includes data like the preferred product, total orders, the most active day of ordering, and email promotion preference. We gather this information by joining our customer profiles table with several subqueries and present this information for the top buyer in each state. 

Output of the Code
![WhatsApp Image 2023-07-22 at 10 25 20 PM](https://github.com/alisahraei20/Data-Analysis/assets/134171185/019ff1af-a012-4077-ae9b-496a9ba2b4f7)

#### DATASET FROM: https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms
