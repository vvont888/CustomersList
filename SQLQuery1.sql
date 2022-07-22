--Challenge 1: In 2013, how many customers did buy the most 15 popular products?
SELECT D.ProductID, COUNT(Distinct CustomerID) as Total_Cust
FROM Sales.SalesOrderHeader H
INNER JOIN Sales.SalesOrderDetail D
ON H.SalesOrderID = D.SalesOrderID
WHERE D.ProductID in 
(
SELECT TOP 15 ProductID
FROM Sales.SalesOrderDetail D
GROUP BY ProductID
ORDER BY COUNT(ProductID) desc
)
and Year(H.OrderDate) = '2013'
Group by D.ProductID

--Ch2: What products did the customers buy in the most 15 popular products list?
SELECT H.CustomerID, D.ProductID
FROM Sales.SalesOrderHeader H
Inner Join Sales.SalesOrderDetail D
ON H.SalesOrderID = D.SalesOrderID
WHERE D.ProductID in
(SELECT TOP 15 ProductID
FROM Sales.SalesOrderDetail D
GROUP BY ProductID
ORDER BY COUNT(ProductID) desc 
) 
AND YEAR(H.OrderDate) = '2013'
GROUP BY H.CustomerID, D.ProductID
ORDER BY H.CustomerID

--Challenge 3: List all customers who bought THE TOP 3 PRODUCTS in the most 15 popular products list 
SELECT H.CustomerID, D.ProductID
FROM Sales.SalesOrderHeader H
Inner Join Sales.SalesOrderDetail D
ON H.SalesOrderID = D.SalesOrderID
WHERE D.ProductID IN
(
SELECT TOP 3 ProductID
FROM Sales.SalesOrderDetail D
GROUP BY ProductID
ORDER BY COUNT(ProductID) DESC 
)
AND YEAR(OrderDate) = 2013
GROUP BY H.CustomerID, D.ProductID
ORDER BY H.CustomerID

--Challenge 4: List all customers who did NOT buy THE TOP 3 PRODUCTS in the most 15 popular products list 
SELECT H.CustomerID, D.ProductID
FROM Sales.SalesOrderHeader H
Inner Join Sales.SalesOrderDetail D
ON H.SalesOrderID = D.SalesOrderID
WHERE D.ProductID NOT IN
(
SELECT TOP 15 ProductID
FROM Sales.SalesOrderDetail D
GROUP BY ProductID
ORDER BY COUNT(ProductID) DESC 
)
AND D.ProductID NOT IN (870,712,873)
GROUP BY H.CustomerID, D.ProductID
ORDER BY H.CustomerID

--Challenge 5:  List all customers who BOUGHT THE TOP 3 PRODUCTS BUT DID NOT BUY THE 4TH in the most 15 popular products list.
WITH #TBL_PRO_ABC_NOTD
AS
(SELECT H.CustomerID,
SUM(CASE WHEN D.ProductID = '870' THEN 1 ELSE 0 END) A,
SUM(CASE WHEN D.ProductID = '712' THEN 1 ELSE 0 END) B,
SUM(CASE WHEN D.ProductID = '873' THEN 1 ELSE 0 END) C,
SUM(CASE WHEN D.ProductID = '921' THEN 1 ELSE 0 END) D
FROM Sales.SalesOrderHeader H
JOIN Sales.SalesOrderDetail D
ON H.SalesOrderID = D.SalesOrderID
WHERE D.ProductID IN 
	(
	SELECT TOP 15 ProductID
	FROM Sales.SalesOrderDetail D
	GROUP BY ProductID
	ORDER BY COUNT(ProductID) desc
	)
GROUP BY H.CustomerID
)
SELECT CustomerID
FROM #TBL_PRO_ABC_NOTD
WHERE A > 0
AND B > 0
AND C > 0
AND D = 0

--Challenge 6: List all customers who BOUGHT THE TOP FIRST and SECOND OR THIRD in the most 15 popular products list (a & b) or (a & c)
WITH #TBL_PRO_ABC_NOTD
AS
(SELECT H.CustomerID, D.ProductID,
SUM(CASE WHEN D.ProductID = '870' THEN 1 ELSE 0 END) A,
SUM(CASE WHEN D.ProductID = '712' THEN 1 ELSE 0 END) B,
SUM(CASE WHEN D.ProductID = '873' THEN 1 ELSE 0 END) C
FROM Sales.SalesOrderHeader H
JOIN Sales.SalesOrderDetail D
ON H.SalesOrderID = D.SalesOrderID
WHERE D.ProductID IN 
	(
	SELECT TOP 15 ProductID
	FROM Sales.SalesOrderDetail D
	GROUP BY ProductID
	ORDER BY COUNT(ProductID) desc
	)
GROUP BY H.CustomerID, D.ProductID
)
SELECT CustomerID, ProductID
FROM #TBL_PRO_ABC_NOTD
WHERE A > 0 AND B > 0 
OR C > 0 

--Challenge 7: List all customers who BOUGHT THE TOP FIRST and SECOND OR THIRD but NOT BOTH 2ND-3RD in the most 15 popular products list (a & b) or (a & c)
