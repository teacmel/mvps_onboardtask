SELECT 
tp.[TenantId],
tp.[PropertyId],
pro.[Name] AS 'Property Name',
CONCAT(adr.[Number],' ',adr.[Street]) AS 'Address',
CONCAT(per.[FirstName],' ',per.[LastName]) AS 'FullName',
pro.[Bedroom],
pro.[Bathroom],
pex.[Amount],
pex.[Date],
pex.[Description],
tp.[PaymentAmount] AS 'Rental payment',
trt.[Name] AS 'Rental Repayment Frequency',
tp.[IsActive] AS 'Status'
FROM [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[TenantProperty] tp
INNER JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[Person] per
ON tp.[TenantId]=per.[Id]
INNER JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[Property] pro
ON pro.[Id] = tp.[PropertyId]
INNER JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[TargetRentType] trt
ON tp.[PaymentFrequencyId] = trt.[Id]
INNER JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[Address] adr
ON adr.[AddressId]= pro.[AddressId]
INNER JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[PropertyExpense] pex
ON pex.[PropertyId] = pro.[Id]
WHERE tp.[IsActive] = '1'
ORDER BY pex.[PropertyId]
