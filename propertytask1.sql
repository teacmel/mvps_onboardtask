--a. Display a list of all property names and their property id’s for Owner Id: 1426. 
SELECT DISTINCT 
[OwnerProperty].[OwnerId],
[Property].[Id],
[Property].[Name] AS PropertyName
FROM [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[Property]
JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[OwnerProperty]
ON [OwnerProperty].[OwnerId]  = 1426
ORDER BY PropertyName

--b.	Display the current home value for each property in question a). 
SELECT DISTINCT
[OwnerProperty].[OwnerId],
[Property].[Id],
[PropertyHomeValue].[IsActive],
[Property].[Name] AS PropertyName,
[PropertyHomeValue].[Value] AS PropertyCurrentValue
FROM [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[Property]
JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[PropertyHomeValue]
ON [PropertyHomeValue].[PropertyId] = [Property].[Id] 
JOIN [MVPSTUDIO.CDVKL5VM8WEQ.AP-SOUTHEAST-2.RDS.AMAZONAWS.COM].[Keys].[dbo].[OwnerProperty]
ON [OwnerProperty].[OwnerId]  = 1426 
WHERE [PropertyHomeValue].[IsActive] = '1'
ORDER BY [Property].[Id]
