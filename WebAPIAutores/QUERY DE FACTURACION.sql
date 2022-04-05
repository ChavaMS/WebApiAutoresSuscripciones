DECLARE @fechaInicio datetime = '2022-04-01';
DECLARE @fechaFin dateTime = '2022-05-01';
DECLARE @montoPorCadaPeticion decimal(4,4) = 1.0/2; -- 2 dolares por cada 1000 peticiones

INSERT INTO Facturas (UsuarioId, Monto, FechaEmision, Pagada, FechaLimiteDePago)
SELECT LlavesAPI.UsuarioId, 
COUNT(*) * @montoPorCadaPeticion AS monto,
GETDATE() AS fechaEmision,
0 AS Pagada,
DATEADD(d, 60, GETDATE()) AS FechaLimiteDePago
FROM Peticiones
INNER JOIN LlavesAPI
ON LLavesAPI.Id = Peticiones.LlaveId
WHERE LlavesAPI.TipoLlave != 1 AND Peticiones.FechaPeticion >= @fechaInicio AND Peticiones.FechaPeticion < @fechaFin
GROUP BY LlavesAPI.UsuarioId;


INSERT INTO FacturasEmitidas(Mes, Año)
SELECT 
	CASE MONTH(GETDATE())
		WHEN 1 THEN 12
		ELSE MONTH(GETDATE()) -1 END AS Mes,

	CASE MONTH(GETDATE())
		WHEN 1 THEN YEAR(GETDATE()) -1
		ELSE YEAR(GETDATE()) END AS Año