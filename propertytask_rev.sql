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
WHERE op.[OwnerId]  = 1426

/*c.For each property in question a), return the following:                                                                      
i.	Using rental payment amount, rental payment frequency, tenant start date and tenant end date to write 
a query that returns the sum of all payments from start date to end date. 
*/
SELECT 
p.[Id] as 'Property ID',
p.[Name] as 'Property Name',
tp.[PaymentAmount],
tp.[StartDate] as 'Tenant Start Date',
tp.[EndDate] as 'Tenant End Date',
trt.[Name] as 'Rental Payment Frequency',

CASE
WHEN FrequencyType = '1' THEN DATEDIFF(WEEK,tp.[StartDate],tp.[EndDate]) * tp.[PaymentAmount]  
WHEN FrequencyType = '2' THEN DATEDIFF(WEEK,tp.[StartDate],tp.[EndDate]) * (tp.[PaymentAmount]/2)
WHEN FrequencyType = '3' THEN DATEDIFF(WEEK,tp.[StartDate],tp.[EndDate])*12*(tp.[PaymentAmount])/52
END as "Sum of all Payments"

FROM dbo.[PropertyRentalPayment] prp
INNER JOIN dbo.[TenantProperty] tp
ON tp.[PropertyId] = prp.[PropertyId]
INNER JOIN dbo.[Property] p
ON p.[Id] = prp.[PropertyId]
FULL JOIN dbo.[TargetRentType] trt
ON trt.[Id] = prp.[FrequencyType]
WHERE tp.[PropertyId] IN ('5597', '5637', '5638')
ORDER BY p.[Id]

 /*c.For each property in question a), return the following:                                                                      
ii.	Display the yield. 
*/
WITH temptable
as (
SELECT tp.[PropertyId], 
(CASE
WHEN tp.[PaymentFrequencyId] = '1' THEN (DATEDIFF(Week,tp.[StartDate],tp.[EndDate])*tp.[PaymentAmount])
WHEN tp.[PaymentFrequencyId] = '2' THEN (DATEDIFF(Week,tp.[StartDate],tp.[EndDate])*tp.[PaymentAmount]/2)
WHEN tp.[PaymentFrequencyId] = '3' THEN (DATEDIFF(Week,tp.[StartDate],tp.[EndDate])*12*tp.[PaymentAmount]/52)
END) as TRP, COALESCE(PE.Amount,0) as Amount, pf.[CurrentHomeValue]
FROM dbo.[TenantProperty] as tp
LEFT JOIN dbo.[PropertyExpense] as pe ON tp.PropertyId = pe.PropertyId
LEFT JOIN dbo.[PropertyFinance] as pf ON tp.PropertyId = pf.PropertyId
    )
SELECT [PropertyId], (TRP-[Amount])/[CurrentHomeValue]*100 as Yield
FROM temptable
WHERE [PropertyId] IN ('5597', '5637', '5638')

--d.	Display all the jobs available
SELECT
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


