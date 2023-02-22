USE TSQLV4;
GO

------------------------------Q1------------------------------
SELECT orderid, orderdate,custid, empid  
FROM Sales.Orders
WHERE YEAR(orderdate) = '2015' AND MONTH(orderdate) = 06
ORDER BY YEAR(orderdate);
GO

------------------------------Q2------------------------------
SELECT orderid , SUM(qty*unitprice) AS 'totalvalue'
FROM Sales.OrderDetails
GROUP BY orderid
HAVING SUM(qty*unitprice) > 10000
ORDER BY totalvalue DESC;
GO


------------------------------Q3------------------------------
/*جواب تمرین سوم در فایل ضمیمه، پیوست شده است*/
-- Query 1
SELECT empid, COUNT(*) AS numorders
FROM Sales.Orders
WHERE orderdate < '20160501'
GROUP BY empid;


-- Query 2
SELECT empid, COUNT(*) AS numorders
FROM Sales.Orders
GROUP BY empid
HAVING MAX(orderdate) < '20160501';

------------------------------Q4------------------------------
SELECT TOP(3) shipcountry, AVG(freight) AS 'avgfreight'
FROM Sales.Orders
WHERE YEAR(orderdate) = '2015'
GROUP BY shipcountry
ORDER BY avgfreight DESC;
