# SQL-practice

### Q1 

Return orders placed in June 2015

Tables involved: TSQLV4 database, Sales.Orders table

---

### Q2

Return orders with total value(qty*unitprice) greater than 10000

sorted by total value

Tables involved: Sales.OrderDetails table

---

### Q3

Explain the difference between the following two queries

##### Query 1 

###### SELECT empid, COUNT(*) AS numorders

###### FROM Sales.Orders

###### WHERE orderdate < '20160501'

###### GROUP BY empid;
<br>

##### Query 2

###### SELECT empid, COUNT(*) AS numorders

###### FROM Sales.Orders

###### GROUP BY empid

###### HAVING MAX(orderdate) < '20160501';

---

### Q4

Return the three ship countries with the highest average freight for orders placed in 2015

Tables involved: Sales.Orders table
