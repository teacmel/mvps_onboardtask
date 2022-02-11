SELECT 
pro.[Name] as 'Property Name',
ps.[FirstName],
ad.[Number] as 'Property Address',
pro.[Bedroom],
pro.[Bathroom],
prenp.[Amount] as 'Rental payment',
prenp.[FrequencyType] as 'Rental Repayment Frequency',
pex.[Description] as 'Expense',
pex.[Amount],
pex.[Date]
FROM dbo.[Property] pro
INNER JOIN dbo.[OwnerProperty] op
ON pro.[Id] = op.[PropertyId]
INNER JOIN dbo.[PropertyRentalPayment] prenp
ON op.[PropertyId]=prenp.[PropertyId]
INNER JOIN dbo.[PropertyExpense] pex
ON op.[PropertyId] = pex.[PropertyId]
INNER JOIN dbo.[Person] ps
ON ps.[Id] = op.[OwnerId]
INNER JOIN dbo.[Address] ad
ON  ad.[AddressId] = pro.[AddressId]
WHERE pro.[Name] = 'Property A'

