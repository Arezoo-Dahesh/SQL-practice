USE TSQLV4;
GO

---------------------------- Q1 ----------------------------
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate = EOMONTH(orderdate);
GO

---------------------------- Q2 ----------------------------
SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname LIKE N'%e%e%';
GO

---------------------------- Q3 ----------------------------
SELECT empid, lastname
FROM HR.Employees
WHERE lastname COLLATE Latin1_General_CS_AS = N'[a-z]%';
GO

---------------------------- Q4 ----------------------------
SELECT custid, orderdate, orderid,
	  COUNT(custid) OVER(PARTITION BY custid
	   ORDER BY custid, orderdate) AS rownum
FROM Sales.Orders
ORDER BY custid, orderdate;
GO

---------------------------- Q5 ----------------------------
SELECT empid, firstname, lastname, titleofcourtesy, 
	   CASE titleofcourtesy
			WHEN 'Ms.' THEN 'Female'
			WHEN 'Mrs.' THEN 'Female'
			WHEN 'Mr.' THEN 'Male'
			ELSE 'Unkown'
	   END AS gender
FROM HR.Employees;
GO

---------------------------- Q6 ----------------------------
SELECT custid, region
FROM Sales.Customers
ORDER BY CASE 
			 WHEN region IS NULL THEN 1
			 ELSE 0 END , region;
GO

---------------------------- Q7 ----------------------------
SELECT E.empid, E.firstname, E.lastname, N.n
FROM dbo.Nums AS N
CROSS JOIN HR.Employees AS E
WHERE N.n <= 5;
GO

---------------------------- Q8 ----------------------------
SELECT E.empid, DATEADD(DAY, n-1, CAST('20160612' AS DATE)) AS dt
FROM dbo.Nums
cross join HR.Employees AS E
WHERE n<= DATEDIFF(DAY, '20160612', '20160616') + 1
ORDER BY E.empid;
GO

---------------------------- Q9 ----------------------------
SELECT C.custid, COUNT(DISTINCT O.orderid) AS numOrders, SUM(OD.qty) AS totalqty
FROM Sales.Customers AS C
	INNER JOIN Sales.Orders AS O
	ON C.custid = O.custid
		INNER JOIN Sales.OrderDetails AS OD
		ON O.orderid = OD.orderid
WHERE shipcountry= N'USA'
GROUP BY C.custid;
GO

---------------------------- Q10 ----------------------------
SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
	LEFT JOIN Sales.Orders AS O
	ON C.custid = O.custid;
GO

---------------------------- Q11 ----------------------------
SELECT C.custid, C.companyname
FROM Sales.Customers AS C
	LEFT JOIN Sales.Orders AS O
	ON C.custid = O.custid 
WHERE O.orderid IS NULL;
GO

---------------------------- Q12 ----------------------------
SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
	INNER JOIN Sales.Orders AS O
	ON C.custid = O.custid
WHERE O.orderdate = '20160212';
GO

---------------------------- Q13 ----------------------------
SELECT DISTINCT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
	LEFT JOIN Sales.Orders AS O
	ON C.custid = O.custid AND O.orderdate = '20160212';
GO

---------------------------- Q14 ----------------------------
SELECT DISTINCT C.custid, C.companyname, 
	  CASE 
	    WHEN O.orderid IS NOT NULL THEN 'YES'
	    ELSE 'NO'
	  END AS HasOrderOn20160212
FROM Sales.Customers AS C
	LEFT JOIN Sales.Orders AS O 
	ON C.custid = O.custid AND O.orderdate ='20160212'
ORDER BY C.custid;
GO

---------------------------- Q15 ----------------------------
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate IN (
		SELECT MAX(orderdate) 
		FROM Sales.Orders);
GO

---------------------------- Q16 ----------------------------
SELECT custid, orderid, orderdate, empid
FROM Sales.Orders
WHERE custid = (
			SELECT custid
			FROM Sales.Orders
			GROUP BY custid
			HAVING COUNT(orderid) =
				(SELECT MAX(countOrderid) 
				FROM (SELECT custid,COUNT(orderid) AS countOrderid
					FROM Sales.Orders
					GROUP BY custid) t1));
GO

---------------------------- Q17 ----------------------------
SELECT DISTINCT E.empid, E.firstname, E.lastname
FROM HR.Employees AS E
WHERE NOT EXISTS(
	SELECT E.empid FROM Sales.Orders AS O
	WHERE O.empid = E.empid and O.orderdate >= '20160501');
GO

---------------------------- Q18 ----------------------------
SELECT DISTINCT C.country
FROM Sales.Customers AS C
WHERE NOT EXISTS(
	SELECT E.country FROM HR.Employees AS E
	WHERE E.country = C.country);
GO

---------------------------- Q19 ----------------------------
SELECT DISTINCT custid, orderid, orderdate, empid
FROM Sales.Orders AS O1
WHERE orderdate = (
	SELECT MAX(orderdate) 
	FROM Sales.Orders AS O2
	WHERE O1.custid = O2.custid)
ORDER BY custid;
GO

---------------------------- Q20 ----------------------------
SELECT DISTINCT C.custid, C.companyname
FROM Sales.Customers AS C
INNER JOIN Sales.Orders AS O
ON C.custid = O.custid
WHERE DATEPART(YEAR,O.orderdate) = 2015  
	  And NOT EXISTS(
		SELECT O.custid
		FROM Sales.Orders AS O
		WHERE C.custid = O.custid AND (DATEPART(YEAR,O.orderdate) = 2016))
ORDER BY custid;
GO

---------------------------- Q21 ----------------------------
SELECT DISTINCT C.custid, C.companyname
FROM Sales.Customers AS C
INNER JOIN Sales.Orders AS O
ON O.custid = C.custid
INNER JOIN Sales.OrderDetails AS OD
ON O.orderid = OD.orderid
WHERE OD.productid = 12 
ORDER BY C.companyname;
GO

---------------------------- Q22 ----------------------------
SELECT custid, CAST(ordermonth AS DATETIME) AS ordermonth, qty, 
	   SUM(qty) OVER(PARTITION BY custid 
					 ORDER BY ordermonth) AS runqty
FROM Sales.CustOrders
ORDER BY custid;
GO

---------------------------- Q23 ----------------------------
SELECT custid, orderdate, orderid, 
	   DATEDIFF(DAY, LAG(orderdate, 1) OVER(PARTITION BY custid
	   ORDER BY orderdate), orderdate)
FROM Sales.Orders AS O1 
ORDER BY custid;
