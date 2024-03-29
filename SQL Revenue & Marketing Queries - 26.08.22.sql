--1 - What is the total Revenue of the company in FY21?

SELECT SUM(Revenue) AS 'Total_Revenue_FY21'
FROM dbo.['Revenue Raw Data$']
WHERE MONTH_ID in (SELECT DISTINCT Month_ID FROM PracticeAug..ipi_Calendar_lookup$ WHERE [Fiscal Year] = 'FY21')


--2 - What is the total Revenue Performance YoY?

SELECT SUM(Revenue) OVER(PARTITION BY fiscal year) AS Revenue_By_Year
From dbo.['Revenue Raw Data$'];

SELECT a.Total_Revenue_FY21, b.Total_Revenue_FY20, a.Total_Revenue_FY21 - b.Total_Revenue_FY20 as Dollar_Dif_Yoy
FROM
(
--FY21
SELECT SUM(Revenue) AS 'Total_Revenue_FY21'
FROM dbo.['Revenue Raw Data$']
WHERE MONTH_ID in (SELECT DISTINCT Month_ID FROM PracticeAug..ipi_Calendar_lookup$ WHERE [Fiscal Year] = 'FY21')
) a,
(
--FY20
SELECT SUM(Revenue) AS 'Total_Revenue_FY20'
FROM dbo.['Revenue Raw Data$']
WHERE MONTH_ID in (SELECT DISTINCT Month_ID FROM PracticeAug..ipi_Calendar_lookup$ WHERE [Fiscal Year] = 'FY20')
) b

--3 - What is the MoM Revenue Performance?

SELECT Total_Revenue_TM, Total_Revenue_LM, Total_Revenue_TM - Total_Revenue_LM AS MoM_Dollar_Diff, Total_Revenue_TM / Total_Revenue_LM AS MoM_Dollar_Diff
FROM
	(
	--this month
	SELECT SUM(Revenue) AS 'Total_Revenue_TM'
	FROM dbo.['Revenue Raw Data$']
	WHERE MONTH_ID in (SELECT MAX(Month_ID) FROM dbo.['Revenue Raw Data$'])
	--GROUP BY Month_ID
	) a,

	(
	--last month
	SELECT SUM(Revenue) AS 'Total_Revenue_LM'
	FROM dbo.['Revenue Raw Data$']
	WHERE MONTH_ID in (SELECT MAX(Month_ID) -1 FROM dbo.['Revenue Raw Data$'])
	) b


--4 - What is the best performing product in terms of revenue this year?

Select *
FROM PracticeAug..['Revenue Raw Data$']

SELECT Product_Category, SUM(Revenue) AS Revenue
FROM PracticeAug..['Revenue Raw Data$']
WHERE Month_ID IN (SELECT DISTINCT MONTH_ID FROM PracticeAug..ipi_Calendar_lookup$ WHERE [Fiscal Year] = 'FY21')
GROUP BY Product_Category
ORDER BY Revenue DESC


--5 - What is the product performance Vs Target for the month?

SELECT a.Product_Category, a.Month_ID, Revenue, Target, Revenue / Target - 1 AS Rev_vs_Target
FROM
	(
	SELECT Product_Category, Month_ID, SUM(Revenue) AS Revenue
	FROM PracticeAug..['Revenue Raw Data$']
	WHERE Month_ID IN (SELECT MAX(Month_ID) FROM dbo.['Revenue Raw Data$'])
	GROUP BY Product_Category, Month_ID
	) a
	LEFT JOIN
	(
	SELECT Product_Category, Month_ID, SUM(Target) AS Target
	FROM dbo.['Targets Raw Data$']
	WHERE Month_ID IN (SELECT MAX(Month_ID) FROM dbo.['Revenue Raw Data$'])
	GROUP BY Product_Category, Month_ID
	) b
	ON a.Month_ID = b.Month_ID AND a.Product_Category = b.Product_Category


--6 - Which account is performing the best in terms of revenue?

SELECT a.Account_No, b.[New Account Name], Revenue
FROM
	(
	SELECT Account_No, SUM(Revenue) AS Revenue
	-- want to look only for specific year? 
	FROM dbo.['Revenue Raw Data$']
	--WHERE Month_ID IN (SELECT DISTINCT MONTH_ID FROM dbo.ipi_Calendar_lookup$ WHERE [Fiscal Year]= 'fy21')
	GROUP BY Account_No) a

	LEFT JOIN
	(SELECT *
	FROM dbo.ipi_account_lookup$) b
	ON 
	a.Account_No = b.[ New Account No ]

ORDER BY Revenue DESC


--7 - Which account is performing the best in terms of revenue vs Target?

SELECT a.Account_No, b.[New Account Name], Revenue, Target, Revenue / NULLIF(Target,0) - 1 AS Rev_Vs_Target
FROM
	(
	SELECT ISNULL(a.Account_No, b.Account_No) AS Account_No, Revenue, Target
	FROM
		(
		SELECT Account_No, SUM(Revenue) AS Revenue
		-- want to look only for specific year? 
		FROM dbo.['Revenue Raw Data$']
		WHERE Month_ID IN (SELECT DISTINCT MONTH_ID FROM dbo.ipi_Calendar_lookup$ WHERE [Fiscal Year]= 'fy21')
		GROUP BY Account_No
		) a

		FULL JOIN
		(
		SELECT Account_No, SUM(Target) AS Target
		FROM dbo.['Targets Raw Data$']
		WHERE Month_ID IN (SELECT DISTINCT MONTH_ID FROM dbo.ipi_Calendar_lookup$ WHERE [Fiscal Year]= 'fy21')
		GROUP BY Account_No
		) b
		ON a.Account_No = b.Account_No
	) a

	LEFT JOIN
	(SELECT *
	FROM dbo.ipi_account_lookup$) b
	ON 
	a.Account_No = b.[ New Account No ]

ORDER BY 5 DESC;

--8 - Which account is performing the worst in terms of meeting targets for the year?

-- Same as above, just change order by to ASC


--9 - Which opportunity has the highest potential and what are the details? FY21

SELECT TOP 1 *
FROM dbo.ipi_Opportunities_Data$
WHERE [Est Completion Month ID] IN (SELECT DISTINCT MONTH_ID FROM dbo.ipi_Calendar_lookup$ WHERE [Fiscal Year]= 'fy21')
ORDER BY [Est Opportunity Value] DESC;

--10 - Which account generates the most revenue per marketing spend for this month? FY21

SELECT ISNULL(a.Account_No, b.Account_No) AS Account_No, Revenue, Marketing_Spend, ISNULL(Revenue,0) / NULLIF(ISNULL(Marketing_Spend,0),0) AS Rev_Per_Spend
FROM 
	(
	SELECT Account_No, SUM(Revenue) AS Revenue
	FROM dbo.['Revenue Raw Data$']
	WHERE Month_ID IN (SELECT DISTINCT MONTH_ID FROM dbo.ipi_Calendar_lookup$ WHERE [Fiscal Year]= 'fy21')
	GROUP BY Account_No
	) a

	FULL JOIN
	(
	SELECT Account_No, SUM([ Marketing Spend ]) AS Marketing_Spend
	FROM dbo.['Marketing Raw Data$']
	WHERE Month_ID IN (SELECT DISTINCT MONTH_ID FROM dbo.ipi_Calendar_lookup$ WHERE [Fiscal Year]= 'fy21')
	GROUP BY Account_No
	) b
	ON a.Account_No = b.Account_No

ORDER BY 4 DESC;
