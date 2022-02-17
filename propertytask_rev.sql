--a. Display a list of all property names and their property id’s for Owner Id: 1426. 
SELECT DISTINCT 
op.[OwnerId],
p.[Id],
p.[Name] as PropertyName
FROM dbo.[Property] p
INNER JOIN dbo.[OwnerProperty] op
ON op.[PropertyId]  = p.[Id]
WHERE op.[OwnerId]  = 1426
ORDER BY PropertyName

--b.	Display the current home value for each property in question a). 
SELECT DISTINCT
p.[Id] as PropertyID,
op.[OwnerId],
phv.[IsActive],
p.[Name] as PropertyName,
phv.[Value] as PropertyCurrentValue
FROM dbo.[Property] p
INNER JOIN dbo.[PropertyHomeValue] phv
ON phv.[PropertyId] = p.[Id] 
INNER JOIN dbo.[OwnerProperty] op
ON op.[PropertyId]  = p.[Id]
WHERE op.[OwnerId]  = 1426 and
phv.[IsActive] = '1'

/*c.For each property in question a), return the following:                                                                      
i.	Using rental payment amount, rental payment frequency, tenant start date and tenant end date to write 
a query that returns the sum of all payments from start date to end date. 
*/
SELECT DISTINCT
p.[Id] as 'Property ID',
p.[Name] as 'Property Name',
prep.[Amount],
tp.[StartDate] as 'Tenant Start Date',
tp.[EndDate] as 'Tenant End Date',

CASE
WHEN FrequencyType = '1' THEN DATEDIFF(WEEK,tp.[StartDate],tp.[EndDate]) * prep.[Amount]  
WHEN FrequencyType = '2' THEN DATEDIFF(WEEK,tp.[StartDate],tp.[EndDate]) * (prep.[Amount]/2)
WHEN FrequencyType = '3' THEN DATEDIFF(WEEK,tp.[StartDate],tp.[EndDate])*12*(prep.[Amount])/52
END as "Sum of all Payments",

CASE
WHEN p.[TargetRentTypeId] = '1' THEN ('Weekly')
WHEN p.[TargetRentTypeId] = '2' THEN ('Fortnightly')
WHEN p.[TargetRentTypeId] = '3' THEN ('Monthly')
END as 'Rental Payment Frequency'

FROM dbo.[Property] p
INNER JOIN dbo.[OwnerProperty] op
ON p.[Id] = op.[PropertyId] 
INNER JOIN dbo.[PropertyRepayment] prep
ON op.[PropertyId]  = prep.[PropertyId]
INNER JOIN dbo.[TenantProperty] tp
ON tp.[PropertyId] = prep.[PropertyId]
WHERE op.[OwnerId]  = 1426
ORDER BY p.[Id]

 /*c.For each property in question a), return the following:                                                                      
ii.	Display the yield. 
*/
WITH #t1
as (
SELECT prep.[PropertyId], 
CASE
WHEN FrequencyType = '1' THEN DATEDIFF(WEEK,tp.[StartDate],tp.[EndDate]) * prep.[Amount]  
WHEN FrequencyType = '2' THEN DATEDIFF(WEEK,tp.[StartDate],tp.[EndDate]) * (prep.[Amount]/2)
WHEN FrequencyType = '3' THEN DATEDIFF(WEEK,tp.[StartDate],tp.[EndDate])*12*(prep.[Amount])/52
END as TRP, COALESCE(PE.Amount,0) as Expense, 
phv.[Value]
FROM dbo.[tenantProperty] tp
LEFT JOIN dbo.[PropertyRepayment] as prep ON prep.PropertyId = tp.PropertyId
LEFT JOIN dbo.[PropertyExpense] as pe ON pe.PropertyId = tp.PropertyId
LEFT JOIN dbo.[PropertyHomeValue] as phv ON tp.PropertyId = phv.PropertyId
WHERE phv.IsActive = '1'
    )
SELECT DISTINCT op.[PropertyId], (TRP-[Expense])/[Value]*100 as Yield
FROM #t1
INNER JOIN dbo.[OwnerProperty] op
ON op.[PropertyId] = #t1.PropertyId
WHERE op.[OwnerId]  = 1426
ORDER by [PropertyId]

--d.	Display all the jobs available
SELECT DISTINCT
jm.[JobId], 
jm.[PropertyId], 
j.[JobDescription],
j.[JobStatusId],
j.[OwnerId],
js.[Status]
FROM dbo.[Job] j
INNER JOIN dbo.[JobStatus] js
ON j.[JobStatusId] = js.[Id]
INNER JOIN dbo.[JobMedia] jm 
ON j.[Id] = jm.[JobId]
WHERE jm.[IsActive] = 1 
AND js.[Status] = 'Open'

/*--e.	Display all property names, current tenants first and last names and 
rental payments per week/ fortnight/month for the properties in question a)
*/
SELECT 
tp.[PropertyId],
prop.[Name] as 'Property Name',
tp.[TenantId],
p.[FirstName],
p.[LastName],
tp.[PaymentAmount],
tpf.[Name] as 'Payment Type' 
From dbo.[TenantProperty] tp 
INNER JOIN dbo.[Person] p
on tp.[TenantId]=p.[Id] 
INNER JOIN dbo.[TenantPaymentFrequencies] tpf
on tp.[PaymentFrequencyId] = tpf.[Id] 
INNER JOIN  dbo.[Property] prop
on prop.[Id] = tp.[PropertyId] WHERE tp.PropertyId  in (SELECT p.[Id]  FROM dbo.[Property] p   INNER JOIN dbo.[OwnerProperty] op  ON p.[Id] = op.[PropertyId] where op.[OwnerId] ='1426')
