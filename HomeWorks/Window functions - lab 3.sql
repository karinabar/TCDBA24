---------------------------------------------------------------------
--
-- Exercise 3
---------------------------------------------------------------------

USE TSQL2012;
GO

---------------------------------------------------------------------
-- Task 1
-- 
--
--  Write a SELECT statement to retrieve the custid, orderid, orderdate, val
--  FROM  Sales.OrderValues view.
--  Add a calculated column named percoftotalcust
--  that contains a percentage value of each order sales amount
--  compared to the total sales amount for that customer. 
--  (Percentage of total vals for the specific customer.)
--
---------------------------------------------------------------------

SELECT custid, orderid, orderdate, val,
cast((val/SUM(Val) over (partition by custid) *100) AS NUMERIC(5,2)) AS percoftotalcust
FROM  Sales.OrderValues
 
---------------------------------------------------------------------
-- Task 2
-- 
-- Copy the previous SELECT statement and add runval.
-- This column should contain a running sales total
-- for each customer based on order date, using orderid as the tiebreaker.
--
---------------------------------------------------------------------

SELECT custid, orderid, orderdate, val,
cast((val/SUM(Val) over (partition by custid) *100) AS NUMERIC(5,2)) AS percoftotalcust,
SUM(val) OVER(PARTITION BY custid ORDER BY orderdate, orderid ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as runval
FROM  Sales.OrderValues
 
