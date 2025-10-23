USE Northwind

--1
SELECT City FROM Employees
INTERSECT
SELECT City FROM Customers;

--2
--a.
SELECT DISTINCT City
FROM Customers
WHERE City NOT IN (
    SELECT DISTINCT City 
    FROM Employees 
    WHERE City IS NOT NULL
);

--b
SELECT City FROM Customers
EXCEPT
SELECT City FROM Employees;

--3
SELECT 
    P.ProductName, 
    ISNULL(SUM(OD.Quantity), 0) AS TotalQuantity
FROM Products AS P
LEFT JOIN [Order Details] AS OD 
    ON P.ProductID = OD.ProductID
GROUP BY P.ProductName
ORDER BY P.ProductName;

--4
SELECT 
    C.City, 
    ISNULL(SUM(OD.Quantity), 0) AS TotalProductsOrdered
FROM Customers AS C
LEFT JOIN Orders AS O 
    ON C.CustomerID = O.CustomerID
LEFT JOIN [Order Details] AS OD 
    ON O.OrderID = OD.OrderID
GROUP BY C.City
ORDER BY C.City;


--5
SELECT 
    City, 
    COUNT(CustomerID) AS NumberOfCustomers
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) >= 2
ORDER BY City;

--6
SELECT 
    C.City, 
    COUNT(DISTINCT OD.ProductID) AS DistinctProductsOrdered
FROM Customers AS C
JOIN Orders AS O 
    ON C.CustomerID = O.CustomerID
JOIN [Order Details] AS OD 
    ON O.OrderID = OD.OrderID
GROUP BY C.City
HAVING COUNT(DISTINCT OD.ProductID) >= 2
ORDER BY C.City;


--7
SELECT DISTINCT C.CompanyName
FROM Customers AS C
JOIN Orders AS O 
    ON C.CustomerID = O.CustomerID
WHERE C.City <> O.ShipCity;

--8
WITH ProductSales AS (
    SELECT
        P.ProductID,
        P.ProductName,
        SUM(OD.Quantity) AS TotalQuantity,
        AVG(OD.UnitPrice * (1 - OD.Discount)) AS AveragePrice
    FROM Products AS P
    JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
    GROUP BY P.ProductID, P.ProductName
),
RankedProductSales AS (
    SELECT
        ProductID,
        ProductName,
        TotalQuantity,
        AveragePrice,
        ROW_NUMBER() OVER (ORDER BY TotalQuantity DESC) AS SalesRank
    FROM ProductSales
),
CityProductSales AS (
    SELECT 
        C.City,
        OD.ProductID,
        SUM(OD.Quantity) AS CityTotalQuantity
    FROM Customers AS C
    JOIN Orders AS O ON C.CustomerID = O.CustomerID
    JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
    GROUP BY C.City, OD.ProductID
),
TopCityPerProduct AS (
    SELECT
        City,
        ProductID,
        CityTotalQuantity,
        ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY CityTotalQuantity DESC) as rn
    FROM CityProductSales
)
SELECT 
    R.ProductName,
    R.TotalQuantity,
    R.AveragePrice,
    T.City AS TopCustomerCity
FROM RankedProductSales AS R
JOIN TopCityPerProduct AS T ON R.ProductID = T.ProductID
WHERE R.SalesRank <= 5 AND T.rn = 1
ORDER BY R.TotalQuantity DESC;


--9
--a
SELECT DISTINCT City
FROM Employees
WHERE City NOT IN (
    SELECT DISTINCT ShipCity 
    FROM Orders 
    WHERE ShipCity IS NOT NULL
);

--b
SELECT City FROM Employees
EXCEPT
SELECT ShipCity FROM Orders;

--10
WITH TopEmployeeCity AS (
   
    SELECT TOP 1 E.City
    FROM Employees AS E
    JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
    GROUP BY E.City
    ORDER BY COUNT(O.OrderID) DESC
),
TopCustomerCity AS (
   
    SELECT TOP 1 C.City
    FROM Customers AS C
    JOIN Orders AS O ON C.CustomerID = O.CustomerID
    JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
    GROUP BY C.City
    ORDER BY SUM(OD.Quantity) DESC
)

SELECT City FROM TopEmployeeCity
INTERSECT
SELECT City FROM TopCustomerCity;

--11
-- Using row number
DELETE T 
FROM
(
SELECT *
, DupRank = ROW_NUMBER() OVER (
              PARTITION BY key_value
              ORDER BY (SELECT NULL)
            )
FROM original_table
) AS T
WHERE DupRank > 1 