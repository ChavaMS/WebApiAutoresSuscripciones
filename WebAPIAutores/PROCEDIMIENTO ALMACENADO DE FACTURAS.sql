-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE CreacionFacturas 
	-- Add the parameters for the stored procedure here
	@fechaInicio datetime,
	@fechaFin dateTime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

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
END
GO
