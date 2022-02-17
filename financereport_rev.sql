SELECT 
op.[PropertyId],
pro.[Name] as 'Property Name',
CONCAT (ps.[FirstName],' ',ps.[LastName]) as 'FullName',
CONCAT (ad.[Number],' ',ad.[Street],' ', ad.[Suburb])as 'Property Address',
pro.[Bedroom],
pro.[Bathroom],
prenp.[Amount] as 'Rental payment',
prenp.[FrequencyType], 
(CASE
WHEN prenp.[FrequencyType] = '1' THEN ('Week')
WHEN prenp.[FrequencyType] = '2' THEN ('Fornight')
WHEN prenp.[FrequencyType] = '3' THEN ('Month')
END) as 'Rental Repayment Frequency',
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
