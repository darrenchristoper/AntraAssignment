
USE AdventureWorks2022
--1
SELECT COUNT(*) AS TotalProducts
FROM Production.Product;
--2
SELECT COUNT(ProductSubcategoryID) AS ProductsWithSubcategory
FROM Production.Product;
--3
SELECT ProductSubcategoryID, COUNT(*) AS CountedProducts
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID;
--4
SELECT COUNT(*) AS ProductsWithoutSubcategory
FROM Production.Product
WHERE ProductSubcategoryID IS NULL;
--5
SELECT SUM(Quantity) AS TotalInventory
FROM Production.ProductInventory;

--6
SELECT ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100;

--7
SELECT Shelf, ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf, ProductID
HAVING SUM(Quantity) < 100;

--8
SELECT AVG(Quantity) AS AverageQuantity
FROM Production.ProductInventory
WHERE LocationID = 10;

--9
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
GROUP BY ProductID, Shelf;

--10
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE Shelf <> 'N/A'
GROUP BY ProductID, Shelf;

--11
SELECT Color, Class, COUNT(*) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class;

--12
SELECT CR.Name AS Country, SP.Name AS Province
FROM Person.CountryRegion AS CR
INNER JOIN Person.StateProvince AS SP
ON CR.CountryRegionCode = SP.CountryRegionCode
ORDER BY Country, Province;

--13
SELECT CR.Name AS Country, SP.Name AS Province
FROM Person.CountryRegion AS CR
INNER JOIN Person.StateProvince AS SP
ON CR.CountryRegionCode = SP.CountryRegionCode
WHERE CR.Name IN ('Germany', 'Canada')
ORDER BY Country, Province;

USE Northwind

--14
SELECT DISTINCT P.ProductName
FROM Products AS P
JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
JOIN Orders AS O ON OD.OrderID = O.OrderID
WHERE O.OrderDate >= DATEADD(year, -27, GETDATE());

--15
SELECT TOP 5 O.ShipPostalCode, SUM(OD.Quantity) AS TotalProductsSold
FROM Orders AS O
JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
WHERE O.ShipPostalCode IS NOT NULL
GROUP BY O.ShipPostalCode
ORDER BY TotalProductsSold DESC;

--16
SELECT TOP 5 O.ShipPostalCode, SUM(OD.Quantity) AS TotalProductsSold
FROM Orders AS O
JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
WHERE 
    O.ShipPostalCode IS NOT NULL 
    AND O.OrderDate >= DATEADD(year, -27, GETDATE())
GROUP BY O.ShipPostalCode
ORDER BY TotalProductsSold DESC;

--17
SELECT City, COUNT(CustomerID) AS NumberOfCustomers
FROM Customers
WHERE City IS NOT NULL
GROUP BY City
ORDER BY City;

--18
SELECT City, COUNT(CustomerID) AS NumberOfCustomers
FROM Customers
WHERE City IS NOT NULL
GROUP BY City
HAVING COUNT(CustomerID) > 2
ORDER BY NumberOfCustomers DESC;

--19
SELECT C.CompanyName, O.OrderDate
FROM Customers AS C
JOIN Orders AS O ON C.CustomerID = O.CustomerID
WHERE O.OrderDate > '1998-01-01'
ORDER BY C.CompanyName, O.OrderDate;

--20
SELECT C.CompanyName, MAX(O.OrderDate) AS MostRecentOrderDate
FROM Customers AS C
JOIN Orders AS O ON C.CustomerID = O.CustomerID
GROUP BY C.CompanyName
ORDER BY MostRecentOrderDate DESC;

--21
SELECT 
    C.CompanyName, 
    ISNULL(SUM(OD.Quantity), 0) AS TotalProductsBought
FROM Customers AS C
LEFT JOIN Orders AS O ON C.CustomerID = O.CustomerID
LEFT JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
GROUP BY C.CompanyName
ORDER BY TotalProductsBought DESC;

--22
SELECT 
    O.CustomerID, 
    SUM(OD.Quantity) AS CountOfProducts
FROM Orders AS O
JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
GROUP BY O.CustomerID
HAVING SUM(OD.Quantity) > 100
ORDER BY CountOfProducts DESC;

--23
SELECT DISTINCT 
    S.CompanyName AS [Supplier Company Name], 
    SH.CompanyName AS [Shipping Company Name]
FROM Suppliers AS S
JOIN Products AS P 
    ON S.SupplierID = P.SupplierID
JOIN [Order Details] AS OD 
    ON P.ProductID = OD.ProductID
JOIN Orders AS O 
    ON OD.OrderID = O.OrderID
JOIN Shippers AS SH 
    ON O.ShipVia = SH.ShipperID
ORDER BY [Supplier Company Name], [Shipping Company Name];

--24
SELECT O.OrderDate, P.ProductName
FROM Orders AS O
JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
JOIN Products AS P ON OD.ProductID = P.ProductID
ORDER BY O.OrderDate, P.ProductName;

--25
SELECT 
    E1.FirstName + ' ' + E1.LastName AS Employee1, 
    E2.FirstName + ' ' + E2.LastName AS Employee2,
    E1.Title
FROM Employees AS E1
JOIN Employees AS E2 ON E1.Title = E2.Title
WHERE E1.EmployeeID < E2.EmployeeID
ORDER BY E1.Title, Employee1, Employee2;

--26
SELECT 
    M.FirstName + ' ' + M.LastName AS ManagerName, 
    COUNT(E.EmployeeID) AS ReportCount
FROM Employees AS E
JOIN Employees AS M ON E.ReportsTo = M.EmployeeID
GROUP BY M.EmployeeID, M.FirstName, M.LastName
HAVING COUNT(E.EmployeeID) > 2
ORDER BY ManagerName;

--27
SELECT 
    City, 
    CompanyName AS Name, 
    ContactName, 
    'Customer' AS Type
FROM Customers

UNION ALL

SELECT 
    City, 
    CompanyName AS Name, 
    ContactName, 
    'Supplier' AS Type
FROM Suppliers

ORDER BY City, Name;