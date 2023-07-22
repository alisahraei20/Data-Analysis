                                  -- Customer Data Analysis-adventureworks2022

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


-- Customer segmentation based on purchasing behavior
SELECT
    CP.CustomerID,
    CP.TotalSpent,
    CP.NumOrders,
    CP.MostPurchasedProduct,
    CASE 
        WHEN TotalSpent > 1000 THEN 'High spender'
        WHEN TotalSpent > 500 THEN 'Medium spender'
        ELSE 'Low spender'
    END AS SpendingCategory,
    CASE 
        WHEN NumOrders > 10 THEN 'Frequent buyer'
        WHEN NumOrders > 5 THEN 'Regular buyer'
        ELSE 'Infrequent buyer'
    END AS BuyingFrequencyCategory,
    TotalSpent / NULLIF(NumOrders, 0) AS AvgOrderValue,
  
    (SELECT TOP 1 PC.Name
     FROM Sales.SalesOrderDetail SOD
     JOIN Production.Product P ON SOD.ProductID = P.ProductID
     JOIN Production.ProductSubcategory PS ON P.ProductSubcategoryID = PS.ProductSubcategoryID
     JOIN Production.ProductCategory PC ON PS.ProductCategoryID = PC.ProductCategoryID
     WHERE SOD.SalesOrderID IN (SELECT SalesOrderID FROM Sales.SalesOrderHeader WHERE CustomerID = CP.CustomerID)
     GROUP BY PC.Name
     ORDER BY COUNT(*) DESC) AS MostPreferredProductCategory,
  
    DATEDIFF(DAY, (SELECT MAX(OrderDate) FROM Sales.SalesOrderHeader WHERE CustomerID = CP.CustomerID), GETDATE()) AS DaysSinceLastPurchase,
    CASE 
        WHEN CP.EmailPromotion = 0 THEN 'No email promotion'
        ELSE (SELECT CASE 
                      WHEN COUNT(*) > 0 THEN 'Email promotion effective'
                      ELSE 'Email promotion not effective'
              END
              FROM Sales.SalesOrderHeader
              WHERE CustomerID = CP.CustomerID AND OrderDate >= DATEADD(MONTH, -6, GETDATE())
             ) 
    END AS EmailPromotionEffectiveness,
  
    (SELECT TOP 1 CASE
                     WHEN SOD.OrderQty > 10 THEN 'Bulk buyer'
                     WHEN SOD.OrderQty between 5 and 10 THEN 'Medium quantity buyer'

                     ELSE 'Small quantity buyer'
                 END
     FROM Sales.SalesOrderDetail SOD
     WHERE SOD.SalesOrderID IN (SELECT SalesOrderID FROM Sales.SalesOrderHeader WHERE CustomerID = CP.CustomerID)
     GROUP BY SOD.OrderQty
     ORDER BY COUNT(*) DESC) AS OrderSizePreference,
  
    (SELECT TOP 1 DATENAME(WEEKDAY, SOH.OrderDate)
     FROM Sales.SalesOrderHeader SOH
     WHERE SOH.CustomerID = CP.CustomerID
     GROUP BY DATENAME(WEEKDAY, SOH.OrderDate)
     ORDER BY COUNT(*) DESC) AS MostActiveDay,
    (SELECT AVG(SOD.OrderQty)
     FROM Sales.SalesOrderDetail SOD
     WHERE SOD.SalesOrderID IN (SELECT SalesOrderID FROM Sales.SalesOrderHeader WHERE CustomerID = CP.CustomerID)) AS AvgPurchaseQuantity,
    (SELECT CASE 
                WHEN SUM(SOH.SubTotal) > (SELECT AVG(SOH.SubTotal)
                                          FROM Sales.SalesOrderHeader SOH
                                          WHERE SOH.CustomerID = CP.CustomerID AND YEAR(SOH.OrderDate) = YEAR(GETDATE()) - 1) THEN 'Spend increased'
                ELSE 'Spend decreased or stayed same'
            END
     FROM Sales.SalesOrderHeader SOH
     WHERE SOH.CustomerID = CP.CustomerID AND YEAR(SOH.OrderDate) = YEAR(GETDATE())) AS SpendTrend
FROM #CustomerProfiles CP;


-- NEXT


-- Add customer geographical information
ALTER TABLE #CustomerProfiles
ADD Country nvarchar(50), State nvarchar(50), City nvarchar(50);

EXEC tempdb.sys.sp_help N'#CustomerProfiles';

UPDATE #CustomerProfiles
SET Country = (
        SELECT TOP 1 CR.Name
        FROM Person.Address A 
        JOIN Person.StateProvince SP ON A.StateProvinceID = SP.StateProvinceID
        JOIN Person.CountryRegion CR ON SP.CountryRegionCode = CR.CountryRegionCode
        JOIN Sales.Customer C ON C.CustomerID = #CustomerProfiles.CustomerID
        WHERE C.PersonID = A.AddressID
    ),
    State = (
        SELECT TOP 1 SP.Name
        FROM Person.Address A 
        JOIN Person.StateProvince SP ON A.StateProvinceID = SP.StateProvinceID
        JOIN Sales.Customer C ON C.CustomerID = #CustomerProfiles.CustomerID
        WHERE C.PersonID = A.AddressID

    ),
    City = (
        SELECT TOP 1 A.City
        FROM Person.Address A 
        JOIN Sales.Customer C ON C.CustomerID = #CustomerProfiles.CustomerID
        WHERE C.PersonID = A.AddressID );

-- Identify top buyers in each state
;WITH StateTopBuyers AS (
    SELECT 
        State,
        CustomerID,
        RANK() OVER (PARTITION BY State ORDER BY TotalSpent DESC) AS SpenderRank
    FROM #CustomerProfiles
)
SELECT 
    STB.State, 
    STB.CustomerID, 
    STB.SpenderRank
FROM StateTopBuyers STB
WHERE STB.SpenderRank <= 3;

-- Identify preferred product category per state
SELECT
    CP.State,
    PC.Name AS PreferredProductCategory
FROM #CustomerProfiles CP
JOIN (
    SELECT
        SOH.CustomerID,
		count(SOH.CustomerID) as NumPurchasePerCategoryForEachCustomerId,
        PS.ProductCategoryID,
        ROW_NUMBER() OVER (PARTITION BY SOH.CustomerID ORDER BY COUNT(*) DESC) AS rn
    FROM Sales.SalesOrderHeader SOH
    JOIN Sales.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
    JOIN Production.Product P ON SOD.ProductID = P.ProductID
    JOIN Production.ProductSubcategory PS ON P.ProductSubcategoryID = PS.ProductSubcategoryID
    GROUP BY SOH.CustomerID, PS.ProductCategoryID
) PCat ON CP.CustomerID = PCat.CustomerID AND PCat.rn = 1
JOIN Production.ProductCategory PC ON PC.ProductCategoryID = PCat.ProductCategoryID;




-- Identify top buyers in each state with additional insights

SELECT 
    t.State, 
    t.CustomerID, 
    t.TotalSpent,
    p.PreferredProduct,
    o.TotalOrders,
    dow.MostActiveDay,
    promo.EmailPromotionPreference
FROM 
(
    SELECT State, CustomerID, TotalSpent, 
        RANK() OVER (PARTITION BY State ORDER BY TotalSpent DESC) as rnk
    FROM #CustomerProfiles
) t
LEFT JOIN 
(
    SELECT 
        cp.CustomerID,
        (SELECT TOP 1 p.Name 
         FROM sales.SalesOrderDetail SOD 
         JOIN Production.Product P ON SOD.ProductID = P.ProductID
         WHERE SOD.SalesOrderID = cp.CustomerID  -- adjusted according to provided schema
         GROUP BY p.Name
         ORDER BY COUNT(*) DESC) as PreferredProduct
    FROM #CustomerProfiles cp
) p ON t.CustomerID = p.CustomerID
LEFT JOIN 
(
    SELECT 
        CustomerID,
        COUNT(*) as TotalOrders
    FROM sales.SalesOrderHeader
    GROUP BY CustomerID
) o ON t.CustomerID = o.CustomerID
LEFT JOIN 
(
    SELECT 
        cp.CustomerID,
        (SELECT TOP 1 DATENAME(WEEKDAY, OrderDate) 
        FROM sales.SalesOrderHeader
        WHERE SalesPersonID = cp.CustomerID  -- adjusted according to provided schema
        GROUP BY DATENAME(WEEKDAY, OrderDate)
        ORDER BY COUNT(*) DESC) as MostActiveDay
    FROM #CustomerProfiles cp
) dow ON t.CustomerID = dow.CustomerID
LEFT JOIN 
(
    SELECT 
        BusinessEntityID AS CustomerID,  -- BusinessEntityID in Person.Person corresponds to CustomerID in sales.Customer
        CASE 
            WHEN EmailPromotion = 1 THEN 'Prefers Email Promotion'
            ELSE 'Does Not Prefer Email Promotion'
        END as EmailPromotionPreference
    FROM Person.Person
) promo ON t.CustomerID = promo.CustomerID
WHERE t.rnk = 1;

