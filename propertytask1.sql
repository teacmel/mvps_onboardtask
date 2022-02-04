--a. Display a list of all property names and their property id’s for Owner Id: 1426. 
SELECT DISTINCT 
[OwnerProperty].[OwnerId],
[Property].[Id],
[Property].[Name] AS PropertyName
FROM [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[Property]
INNER JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[OwnerProperty]
ON [OwnerProperty].[PropertyId]  = [Property].[Id]
WHERE [OwnerProperty].[OwnerId]  = 1426
ORDER BY PropertyName

--b.	Display the current home value for each property in question a). 
SELECT DISTINCT
[Property].[Id] AS PropertyID,
[OwnerProperty].[OwnerId],
[PropertyHomeValue].[IsActive],
[Property].[Name] AS PropertyName,
[PropertyHomeValue].[Value] AS PropertyCurrentValue
FROM [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[Property]
INNER JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[PropertyHomeValue]
ON [PropertyHomeValue].[PropertyId] = [Property].[Id] 
INNER JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[OwnerProperty]
ON [OwnerProperty].[PropertyId]  = [Property].[Id]
WHERE [OwnerProperty].[OwnerId]  = 1426 and
 [PropertyHomeValue].[IsActive] = '1'

/*c.For each property in question a), return the following:                                                                      
i.	Using rental payment amount, rental payment frequency, tenant start date and tenant end date to write 
a query that returns the sum of all payments from start date to end date. 
*/
--Property 5597 and 5638 in weekly repayment frequency
SELECT 
[PropertyHomeValue].[PropertyId] AS Property,
[Amount],
[StartDate],
[EndDate],
[FrequencyType],
[PropertyHomeValue].[Value] AS PropertyCurrentValue,
[PropertyHomeValue].[IsActive],
(DATEDIFF(wk,[PropertyRepayment].[StartDate],[PropertyRepayment].[EndDate]) * [PropertyRepayment].[Amount]) AS "Sum of Rental" 
FROM [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[PropertyRepayment]
INNER JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[PropertyHomeValue]
ON [PropertyHomeValue].[PropertyId] = [PropertyRepayment].[PropertyId]
WHERE [PropertyRepayment].[PropertyId] = 5597 OR 
[PropertyRepayment].[PropertyId] = 5638 AND
 [PropertyHomeValue].[IsActive] = '1'

--Property 5637 is in fortnighly repayment frequency
SELECT 
[PropertyHomeValue].[PropertyId] AS Property,
[Amount],
[StartDate],
[EndDate],
[FrequencyType],
[PropertyHomeValue].[Value] AS PropertyCurrentValue,
[PropertyHomeValue].[IsActive],
(DATEDIFF(wk,[PropertyRepayment].[StartDate],[PropertyRepayment].[EndDate]) * [PropertyRepayment].[Amount]/2) AS "Sum of Rental" 
FROM [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[PropertyRepayment]
INNER JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[PropertyHomeValue]
ON [PropertyHomeValue].[PropertyId] = [PropertyRepayment].[PropertyId]
WHERE [PropertyRepayment].[PropertyId] = 5637 AND
 [PropertyHomeValue].[IsActive] = '1'

 /*c.For each property in question a), return the following:                                                                      
ii.	Display the yield. 
*/
--Property 5597 and 5638 in weekly repayment frequency
SELECT 
[PropertyHomeValue].[PropertyId] AS Property,
[Amount],
[StartDate],
[EndDate],
[FrequencyType],
[PropertyHomeValue].[Value] AS PropertyCurrentValue,
[PropertyHomeValue].[IsActive], 
((DATEDIFF(wk,[PropertyRepayment].[StartDate],[PropertyRepayment].[EndDate]) * [PropertyRepayment].[Amount])/[PropertyHomeValue].[Value]) * 100 AS "Yield" 
FROM [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[PropertyRepayment]
INNER JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[PropertyHomeValue]
ON [PropertyHomeValue].[PropertyId] = [PropertyRepayment].[PropertyId]
WHERE [PropertyRepayment].[PropertyId] = 5597 OR 
[PropertyRepayment].[PropertyId] = 5638 AND
 [PropertyHomeValue].[IsActive] = '1'

--Property 5637 in fortnighly repayment frequency
SELECT 
[PropertyHomeValue].[PropertyId] AS Property,
[Amount],
[StartDate],
[EndDate],
[FrequencyType],
[PropertyHomeValue].[Value] AS PropertyCurrentValue,
[PropertyHomeValue].[IsActive], 
((DATEDIFF(wk,[PropertyRepayment].[StartDate],[PropertyRepayment].[EndDate]) * [PropertyRepayment].[Amount]/2)/[PropertyHomeValue].[Value]) * 100 AS "Yield" 
FROM [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[PropertyRepayment]
INNER JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[PropertyHomeValue]
ON [PropertyHomeValue].[PropertyId] = [PropertyRepayment].[PropertyId]
WHERE [PropertyRepayment].[PropertyId] = 5637 AND
 [PropertyHomeValue].[IsActive] = '1'

 --d.	Display all the jobs available
SELECT DISTINCT
[JobDescription]  AS 'Jobs Available'
FROM [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[Job]

/*--e.	Display all property names, current tenants first and last names and 
rental payments per week/ fortnight/month for the properties in question a)
*/
SELECT [TenantId]
      ,[PropertyId]
	  ,[Property].[Name] AS 'Property Name'
	  ,[FirstName]
	  ,[LastName]
      ,[StartDate]
      ,[EndDate]
      ,[PaymentFrequencyId]
      ,[PaymentAmount]
	  ,[TargetRentType].[Name] AS 'Rental Repayment Frequency'
	  ,[TenantProperty].[IsActive] AS 'Status'
FROM [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[TenantProperty]
JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[Person]
ON [TenantProperty].[TenantId]=[Person].[Id]
JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[Property]
ON [Property].[Id] = [TenantProperty].[PropertyId]
JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[TargetRentType]
ON [TenantProperty].[PropertyId] = 5597 OR 
[TenantProperty].[PropertyId] = 5637 OR
[TenantProperty].[PropertyId] = 5638 