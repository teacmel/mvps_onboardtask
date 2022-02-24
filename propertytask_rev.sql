--a. Display a list of all property names and their property id’s for Owner Id: 1426. 
SELECT DISTINCT 
op.[OwnerId],
p.[Id],
p.[Name] as PropertyName
FROM [Property] p
INNER JOIN [OwnerProperty] op
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
FROM [Property] p
INNER JOIN [PropertyHomeValue] phv
ON phv.[PropertyId] = p.[Id] 
INNER JOIN [OwnerProperty] op
ON op.[PropertyId]  = p.[Id]
WHERE op.[OwnerId]  = 1426 and
phv.[IsActive] = '1'

/*c.For each property in question a), return the following:                                                                      
i.	Using rental payment amount, rental payment frequency, tenant start date and tenant end date to write a query that returns the sum of all payments from start date to end date. 
*/
SELECT 
p.[Id] as PropertyID, 
p.[Name] as PropertyName, 
CASE
WHEN trt.[Name] ='Weekly' THEN (DATEDIFF(wk,tp.[StartDate], tp.[EndDate])*prp.[Amount])
WHEN trt.[Name] ='Fortnightly' THEN ((DATEDIFF(wk,tp.[StartDate], tp.[EndDate])/2)*prp.[Amount])
ELSE (DATEDIFF(m,tp.[StartDate], tp.[EndDate])*prp.[Amount])
END AS SumOfPayments, 
trt.[Name] as RentalPaymentFrequency, 
prp.[Amount] as RentalPaymentAmount, 
tp.[StartDate] as TenantStartDate, 
tp.[EndDate] as TenantEndDate
FROM Property as p
INNER JOIN [OwnerProperty] op ON p.[Id]=op.[PropertyId]
INNER JOIN [PropertyRentalPayment] prp ON p.[Id]=prp.[PropertyId]
INNER JOIN [TargetRentType] trt ON prp.[FrequencyType]=trt.[Id]
INNER JOIN [TenantProperty] tp ON p.[Id]=tp.[PropertyId]
WHERE op.[OwnerId]=1426;

 /*c.For each property in question a), return the following:                                                                      
<<<<<<< HEAD
ii.	Display the yield. 
*/
SELECT 
p.[Id] as PropertyID,
p.[Name] as PropertyName, 
phv.[Value] as HomeValue, 
(
    (
        (CASE
WHEN trt.[Name] ='Weekly' THEN (DATEDIFF(wk,tp.[StartDate], tp.[EndDate])*prp.[Amount])
WHEN trt.[Name] ='Fortnightly' THEN ((DATEDIFF(wk,tp.[StartDate], tp.[EndDate])/2)*prp.[Amount])
ELSE (DATEDIFF(m,tp.[StartDate], tp.[EndDate])*prp.[Amount])
END
        )-ISNULL(SUM(pe.[Amount]),0)
    )/phv.[Value]
)*100 as Yield
, prp.[Amount] as RentalPaymentAmount
, trt.[Name] as RentalPaymentFrequency
, tp.[StartDate] as TenantStartDate
, tp.[EndDate] as TenantEndDate
FROM Property as p
INNER JOIN [OwnerProperty] op ON p.[Id]=op.[PropertyId]
INNER JOIN [PropertyRentalPayment] prp ON p.[Id]=prp.[PropertyId]
INNER JOIN [TargetRentType] trt ON prp.[FrequencyType]=trt.[Id]
INNER JOIN [TenantProperty] tp ON p.[Id]=tp.[PropertyId]
INNER JOIN [PropertyHomeValue] phv ON p.[Id]=phv.[PropertyId]
LEFT JOIN [PropertyExpense] pe ON p.[Id]=pe.[PropertyId]
WHERE op.OwnerId=1426 AND phv.[IsActive]=1
GROUP BY p.[Name],p.[Id],phv.[Value],trt.[Name],prp.[Amount],tp.[StartDate],tp.[EndDate];

--d.	Display all the jobs available
SELECT DISTINCT 
j.Id as JobID, 
j.[JobDescription], 
j.[OwnerId], 
j.[PropertyId], 
jm.[IsActive]
FROM Job as j
INNER JOIN [JobMedia] jm ON j.[Id]=jm.[JobId]
WHERE jm.[IsActive]=1

/*--e.	Display all property names, current tenants first and last names and 
rental payments per week/ fortnight/month for the properties in question a)
*/
SELECT 
p.[Name] as PropertyName, 
per.FirstName as TenantFirstName, 
per.LastName as TenantLastName, 
trt.[Name] as RentalPaymentFrequency,
prp.[Amount] as RentalPaymentAmount 
FROM [OwnerProperty] op
INNER JOIN [Property] p ON op.PropertyId=p.Id
INNER JOIN [TenantProperty] tp ON p.Id=tp.PropertyId
INNER JOIN [Tenant] t ON tp.TenantId=t.Id
INNER JOIN [Person] per ON t.Id=per.Id
INNER JOIN [PropertyRentalPayment] prp ON p.Id=prp.PropertyId
INNER JOIN TargetRentType AS trt ON prp.FrequencyType=trt.Id
WHERE op.[OwnerId]=1426;
