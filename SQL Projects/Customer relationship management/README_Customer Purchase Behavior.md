
Problem Statement
Understanding customer behavior and segmenting customers based on their purchasing patterns is crucial for businesses to tailor their marketing strategies and improve customer satisfaction. However, analyzing customer data from the AdventureWorks database to identify and categorize customers can be complex and time-consuming.
# Customer Segmentation based on Purchasing Behavior


## Objectives
The objectives of this code segment are as follows:


- Perform customer segmentation based on purchasing behavior, using the `#CustomerProfiles` temporary table created in the previous code segment. This involves calculating various metrics and attributes for each customer.


- Determine the customer's spending category (`SpendingCategory`) based on their total spend (`TotalSpent`), classifying them as either "High spender," "Medium spender," or "Low spender" using specific thresholds.


- Determine the buying frequency category (`BuyingFrequencyCategory`) for each customer based on their number of orders (`NumOrders`). Customers will be classified as either "Frequent buyer," "Regular buyer," or "Infrequent buyer" based on predefined thresholds.


- Calculate the average order value (`AvgOrderValue`) for each customer by dividing their total spend (`TotalSpent`) by the number of orders (`NumOrders`). Special care is taken to avoid division by zero using the `NULLIF` function.


- Identify the most preferred product category (`MostPreferredProductCategory`) for each customer based on the products they have purchased the most. This is determined by analyzing the associated product categories from the `Sales.SalesOrderDetail` table, joining with other relevant tables such as `Production.Product`, `Production.ProductSubcategory`, and `Production.ProductCategory`.


- Determine the number of days since the customer's last purchase (`DaysSinceLastPurchase`) by calculating the difference between the current date (`GETDATE()`) and the most recent order date associated with the customer.


- Evaluate the effectiveness of email promotions (`EmailPromotionEffectiveness`) for each customer. If a customer has not opted for email promotion (`EmailPromotion = 0`), it will be classified as "No email promotion." Otherwise, the code checks if the customer has placed any orders in the last 6 months (`DATEADD(MONTH, -6, GETDATE())`). If they have, the email promotion is considered "effective"; otherwise, it is labeled as "not effective."


- Determine the customer's preference for order size (`OrderSizePreference`). This is done by analyzing the order quantities (`OrderQty`) in the `Sales.SalesOrderDetail` table associated with the customer, considering categories such as "Bulk buyer," "Medium quantity buyer," or "Small quantity buyer" based on predefined thresholds.


- Identify the most active day (`MostActiveDay`) of the week for each customer based on their order dates. This is achieved by grouping the order dates (`OrderDate`) by the weekday name (`DATENAME(WEEKDAY, SOH.OrderDate)`) and selecting the most frequently occurring weekday.


- Calculate the average purchase quantity (`AvgPurchaseQuantity`) for each customer by examining the order quantities (`OrderQty`) associated with their sales orders in the `Sales.SalesOrderDetail` table.


- Evaluate the customer's spending trend (`SpendTrend`) by comparing their total spend (`TotalSpent`) for the current year with the average spend in the previous year. Customers with increased spending are classified as "Spend increased," while those with decreased or consistent spending are labeled as "Spend decreased or stayed same."


By accomplishing these objectives, businesses can gain valuable insights into customer segments, their spending patterns, preferences, and trends. This information can aid in targeted marketing campaigns, personalized customer experiences, and overall business growth.






# Customer Purchasing Behavior Analysis ## Step-by-Step Process 
1. **Create Spending and Buying Frequency Categories:** Categorize customers into 'High spender', 'Medium spender', or 'Low spender' based on total amount spent, and 'Frequent buyer', 'Regular buyer', or 'Infrequent buyer' based on the number of orders. 
2. **Calculate Average Order Value:** Compute the average value of orders for each customer by dividing total spent by the number of orders. Handle cases where the number of orders is zero to avoid division by zero errors. 
3. **Identify Most Preferred Product Category:** For each customer, find the product category which appears most often in their purchases. 
4. **Calculate Days Since Last Purchase:** Compute the number of days since each customer's last purchase. 
5. **Evaluate Email Promotion Effectiveness:** If the customer does not receive email promotions, label them as 'No email promotion'. If they do receive promotions, analyze their purchase history from the last 6 months to determine if the promotions are effective. 
6. **Identify Order Size Preference:** For each customer, identify their typical order size ('Bulk buyer', 'Medium quantity buyer', 'Small quantity buyer') based on the quantity of items in their most common order size. 
7. **Find Most Active Day:** Determine the weekday on which each customer is most likely to place an order. 
8. **Calculate Average Purchase Quantity:** Compute the average quantity of items in each customer's orders. 
9. **Identify Spend Trend:** Compare each customer's total spend this year to their average spend last year to identify if their spend has increased or stayed the same/decreased. 
At the end of this process, you should have a comprehensive view of each customer's purchasing behavior, allowing for more effective targeting in marketing efforts and potentially leading to increased customer satisfaction and sales.


### Output of the Code
