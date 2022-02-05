--a. Display a list of all property names and their property id’s for Owner Id: 1426. 
SELECT DISTINCT 
op.[OwnerId],
p.[Id],
p.[Name] AS PropertyName
FROM [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[Property] p
INNER JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[OwnerProperty] op
ON op.[PropertyId]  = p.[Id]
WHERE op.[OwnerId]  = 1426
ORDER BY PropertyName

--b.	Display the current home value for each property in question a). 
SELECT DISTINCT
p.[Id] AS PropertyID,
op.[OwnerId],
phv.[IsActive],
p.[Name] AS PropertyName,
phv.[Value] AS PropertyCurrentValue
FROM [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[Property] p
INNER JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[PropertyHomeValue] phv
ON phv.[PropertyId] = p.[Id] 
INNER JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[OwnerProperty] op
ON op.[PropertyId]  = p.[Id]
WHERE op.[OwnerId]  = 1426 and phv.[IsActive] = '1'

/*c.For each property in question a), return the following:                                                                      
i.	Using rental payment amount, rental payment frequency, tenant start date and tenant end date to write 
a query that returns the sum of all payments from start date to end date. 
*/
--Property 5597 and 5638 in weekly repayment frequency
SELECT 
phv.[PropertyId] AS Property,
pr.[Amount],
pr.[StartDate],
pr.[EndDate],
pr.[FrequencyType],
phv.[Value] AS PropertyCurrentValue,
phv.[IsActive],
(DATEDIFF(wk,pr.[StartDate],pr.[EndDate]) * pr.[Amount]) AS "Sum of Rental" 
FROM [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[PropertyRepayment] pr
INNER JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[PropertyHomeValue] phv
ON phv.[PropertyId] = pr.[PropertyId]
WHERE pr.[PropertyId] = 5597 OR 
pr.[PropertyId] = 5638 AND phv.[IsActive] = '1'

--Property 5637 is in fortnighly repayment frequency
SELECT 
phv.[PropertyId] AS Property,
pr.[Amount],
pr.[StartDate],
pr.[EndDate],
pr.[FrequencyType],
phv.[Value] AS PropertyCurrentValue,
phv.[IsActive],
(DATEDIFF(wk,pr.[StartDate],pr.[EndDate]) * pr.[Amount]/2) AS "Sum of Rental" 
FROM [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[PropertyRepayment] pr
INNER JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[PropertyHomeValue] phv
ON phv.[PropertyId] = pr.[PropertyId]
WHERE pr.[PropertyId] = 5637 AND phv.[IsActive] = '1'

 /*c.For each property in question a), return the following:                                                                      
ii.	Display the yield. 
*/
--Property 5597 and 5638 in weekly repayment frequency
SELECT 
phv.[PropertyId] AS Property,
pr.[Amount],
pr.[StartDate],
pr.[EndDate],
pr.[FrequencyType],
phv.[Value] AS PropertyCurrentValue,
phv.[IsActive], 
((DATEDIFF(wk,pr.[StartDate],pr.[EndDate]) * pr.[Amount])/phv.[Value]) * 100 AS "Yield" 
FROM [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[PropertyRepayment] pr
INNER JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[PropertyHomeValue] phv
ON phv.[PropertyId] = pr.[PropertyId]
WHERE pr.[PropertyId] = 5597 OR 
pr.[PropertyId] = 5638 AND phv.[IsActive] = '1'

--Property 5637 in fortnighly repayment frequency
SELECT 
phv.[PropertyId] AS Property,
pr.[Amount],
pr.[StartDate],
pr.[EndDate],
pr.[FrequencyType],
phv.[Value] AS PropertyCurrentValue,
phv.[IsActive], 
((DATEDIFF(wk,pr.[StartDate],pr.[EndDate]) * pr.[Amount])/phv.[Value]) * 100 AS "Yield" 
FROM [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[PropertyRepayment] pr
INNER JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[PropertyHomeValue] phv
ON phv.[PropertyId] = pr.[PropertyId]
WHERE pr.[PropertyId] = 5637 AND phv.[IsActive] = '1'

 --d.	Display all the jobs available
SELECT DISTINCT
[JobDescription]  AS 'Jobs Available'
FROM [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[Job]

/*--e.	Display all property names, current tenants first and last names and 
rental payments per week/ fortnight/month for the properties in question a)
*/
SELECT 
tp.[TenantId],
tp.[PropertyId],
pro.[Name] AS 'Property Name',
per.[FirstName],
per.[LastName],
tp.[StartDate],
tp.[EndDate],
tp.[PaymentFrequencyId],
tp.[PaymentAmount],
trt.[Name] AS 'Rental Repayment Frequency',
tp.[IsActive] AS 'Status'
FROM [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[TenantProperty] tp
JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[Person] per
ON tp.[TenantId]=per.[Id]
JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[Property] pro
ON pro.[Id] = tp.[PropertyId]
JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[TargetRentType] trt
ON tp.[PropertyId] = 5597 OR 
tp.[PropertyId] = 5637 OR
tp.[PropertyId] = 5638 