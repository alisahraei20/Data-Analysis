-- Constructing a Customer Profile Table from Multiple Data Sources - Microsoft AdventureWorks database 2022

use adventureworks2022;

-- Create a temporary table for customer profiles
CREATE TABLE #CustomerProfiles
(
  CustomerID int,
  FirstName nvarchar(50),
  LastName nvarchar(50),
  EmailPromotion int,
  TotalSpent money,
  NumOrders int,
  MostPurchasedProduct int

);

-- Populate the table with customer data
INSERT INTO #CustomerProfiles
SELECT 
    C.CustomerID, 
    P.FirstName, 
    P.LastName,
    P.EmailPromotion,
    (SELECT SUM(SOH.SubTotal) 
     FROM Sales.SalesOrderHeader SOH 
     WHERE C.CustomerID = SOH.CustomerID) AS TotalSpent,
    (SELECT COUNT( distinct SOH.SalesOrderID) 
     FROM Sales.SalesOrderHeader SOH 
     WHERE C.CustomerID = SOH.CustomerID) AS NumOrders,
    (SELECT TOP 1 SOD.ProductID 
     FROM Sales.SalesOrderHeader SOH 
     JOIN Sales.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
     WHERE SOH.CustomerID = C.CustomerID
     GROUP BY SOD.ProductID 
     ORDER BY COUNT(*) DESC) AS MostPurchasedProduct
FROM Sales.Customer C
JOIN Person.Person P ON C.PersonID = P.BusinessEntityID;

select * from #CustomerProfiles;
