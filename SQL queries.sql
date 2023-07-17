-- 1. What are the top 5 brands by receipts scanned for most recent month?
## Definition of most recent month: scanned date is within 30 days
SELECT * FROM(
SELECT B.BrandID, B.Name, COUNT(R.ReceiptID), RANK() OVER (ORDER BY COUNT(R.ReceiptID) DESC) ScanRank FROM Receipts R
LEFT JOIN ReceiptItem RI ON R.ReceiptID = RI.ReceiptID
LEFT JOIN Brand B ON RI.barcode = B.barcode
WHERE current_date() - dateScanned <= 30
GROUP BY 1, 2
)T
WHERE ScanRank <= 5;


-- 2. How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?
## Definition of previous month: scanned date is within 30 - 60 days
SELECT * FROM(
SELECT B.BrandID, B.Name, COUNT(R.ReceiptID), RANK() OVER (ORDER BY COUNT(R.ReceiptID) DESC) ScanRank FROM Receipts R
LEFT JOIN ReceiptItem RI ON R.ReceiptID = RI.ReceiptID
LEFT JOIN Brand B ON RI.barcode = B.barcode
WHERE current_date() - dateScanned <= 60
AND current_date() - dateScanned > 30
GROUP BY 1, 2
)T
WHERE ScanRank <= 5;
# Compare difference between Question 1 and Question 2

-- 3. When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
SELECT rewardsReceiptStatus, AVG(totalSpent) AS AVG_Spend FROM Receipts
WHERE rewardsReceiptStatus IN ('Accepted', 'Rejected') ## Actually DataBase Use "FINISHED" Instead 
GROUP BY 1;

-- 4. When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
SELECT rewardsReceiptStatus, SUM(purchasedItemCount) AS TotalItemPurchased FROM Receipts
WHERE rewardsReceiptStatus IN ('Accepted', 'Rejected') ## Actually DataBase Use "FINISHED" Instead 
GROUP BY 1;

-- 5. Which brand has the most spend among users who were created within the past 6 months?

SELECT B.BrandID, B.Name, SUM(finalPrice * quantityPurchased) AS TotalSpend FROM Receipts R
LEFT JOIN ReceiptItem RI ON R.ReceiptID = RI.ReceiptID
LEFT JOIN Brand B ON RI.barcode = B.barcode
LEFT JOIN Users B ON Users.UserID = R.UserID
WHERE current_date() - U.createdDate <= 180 # users created within the past 6 months
GROUP BY 1, 2
ORDER BY TotalSpend DESC;


-- 6. Which brand has the most transactions among users who were created within the past 6 months?
SELECT B.BrandID, B.Name, COUNT(R.ReceiptID) AS TotalTransactions FROM Receipts R
LEFT JOIN ReceiptItem RI ON R.ReceiptID = RI.ReceiptID
LEFT JOIN Brand B ON RI.barcode = B.barcode
LEFT JOIN Users B ON Users.UserID = R.UserID
WHERE current_date() - U.createdDate <= 180 # users created within the past 6 months
GROUP BY 1, 2
ORDER BY TotalTransactions DESC
 