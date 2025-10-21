USE AdventureWorks2022
--Retrieve ProductID, Name, Color and ListPrice from the Production.Product table 
--1
--no filter
SELECT Product.ProductID , Product.Name, Product.Color,Product.ListPrice 
FROM Production.Product as Product 
--2
--excludes the rows that ListPrice is 0 
SELECT Product.ProductID , Product.Name, Product.Color,Product.ListPrice 
FROM Production.Product as Product
WHERE Product.ListPrice != 0
--3
--rows that are NULL for the Color column.
SELECT Product.ProductID , Product.Name, Product.Color,Product.ListPrice 
FROM Production.Product as Product
WHERE Product.Color IS NULL
--4
--rows that are not NULL for the Color column.
SELECT Product.ProductID , Product.Name, Product.Color,Product.ListPrice 
FROM Production.Product as Product
WHERE Product.Color IS NOT NULL
--5
--rows that are not NULL for the column Color, and the column ListPrice has a value greater than zero.
SELECT Product.ProductID , Product.Name, Product.Color,Product.ListPrice 
FROM Production.Product as Product
WHERE Product.Color IS NOT NULL 
AND Product.ListPrice > 0 
--6
-- Write a query that concatenates the columns Name and Color from the Production.
-- Product table by excluding the rows that are null for color.
SELECT Product.Name + ' ' + Product.Color AS ProductDescription
FROM Production.Product as Product
WHERE Color IS NOT NULL;
--7
-- Write a query that generates the following result set  from Production.Product:
SELECT 'NAME: ' + Product.Name + '  --  COLOR: ' + Product.Color AS ProductInfo
FROM Production.Product as Product
WHERE Color IS NOT NULL;
--8
--Write a query to retrieve the to the columns ProductID and Name from the Production.
--Product table filtered by ProductID from 400 to 500
SELECT Product.ProductID , Product.Name 
FROM Production.Product as Product
WHERE Product.ProductID >=400 AND Product.ProductID <=500
--9
--restricted to the colors black and blue--
SELECT Product.ProductID , Product.Name
FROM Production.Product as Product
WHERE Product.Color IN ('black ', 'blue')
--10
--Write a query to get a result set on products that begins with the letter S. --
SELECT *
FROM Production.Product
WHERE Name LIKE 'S%'
--11
--Write a query that retrieves the columns Name and ListPrice from the Production.Product table. Your result set should look something like the following.
-- Order the result set by the Name column
SELECT Product.Name , Product.ListPrice 
FROM Production.Product as Product
WHERE Name LIKE 'S%'
ORDER BY Product.Name ASC
--12
--Write a query that retrieves the columns Name and ListPrice from the Production.Product table. Your result set should look something like the following.
-- Order the result set by the Name column
--The products name should start with either 'A' or 'S'
SELECT Product.Name , Product.ListPrice 
FROM Production.Product as Product
WHERE Name LIKE '[AS]%'
ORDER BY Product.Name ASC
--13
--Write a query so you retrieve rows that have a Name that begins with the letters SPO, but is then not followed by the letter K. 
--After this zero or more letters can exists. Order the result set by the Name column.
SELECT Product.Name, Product.ListPrice
FROM Production.Product as Product
WHERE Product.Name LIKE 'SPO[^K]%'
ORDER BY Name;
--14
--Write a query that retrieves unique colors from the table Production.Product. 
--Order the results  in descending  manner.
SELECT DISTINCT Product.Color
FROM Production.Product as Product
ORDER BY Color DESC;
