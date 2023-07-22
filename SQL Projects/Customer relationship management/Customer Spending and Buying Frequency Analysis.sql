                               -- Customer Spending and Buying Frequency Analysis-

-- Add SpendingCategory and BuyingFrequencyCategory to the table

ALTER TABLE #CustomerProfiles
ADD SpendingCategory nvarchar(50), BuyingFrequencyCategory nvarchar(50);

-- Update the new columns based on TotalSpent and NumOrders

UPDATE #CustomerProfiles
SET SpendingCategory = CASE 
        WHEN TotalSpent > 1000 THEN 'High spender'
        WHEN TotalSpent > 500 THEN 'Medium spender'
        ELSE 'Low spender'
    END,
    BuyingFrequencyCategory = CASE 
        WHEN NumOrders > 10 THEN 'Frequent buyer'
        WHEN NumOrders > 5 THEN 'Regular buyer'
        ELSE 'Infrequent buyer'
    END;


-- Analyzing aggregated customer behavior
-- Average Spending and Order Frequency

SELECT
    AVG(TotalSpent) AS AverageSpending,
    AVG(NumOrders) AS AverageOrderFrequency,
    SUM(CASE WHEN SpendingCategory = 'High spender' THEN 1 ELSE 0 END) AS NumHighSpenders,
    SUM(CASE WHEN BuyingFrequencyCategory = 'Frequent buyer' THEN 1 ELSE 0 END) AS NumFrequentBuyers
FROM #CustomerProfiles;

-- Most popular products among high spenders

SELECT
    MostPurchasedProduct,
    COUNT(*) AS NumHighSpenders
FROM #CustomerProfiles
WHERE SpendingCategory = 'High spender'
GROUP BY MostPurchasedProduct
ORDER BY NumHighSpenders DESC;

-- Most popular products among frequent buyers

SELECT
    MostPurchasedProduct,
    COUNT(*) AS NumFrequentBuyers
FROM #CustomerProfiles
WHERE BuyingFrequencyCategory = 'Frequent buyer'
GROUP BY MostPurchasedProduct
ORDER BY NumFrequentBuyers DESC;

