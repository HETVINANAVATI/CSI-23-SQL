USE [csi23sql]
GO
/****** Object:  StoredProcedure [dbo].[getColumnNames]    Script Date: 7/28/2023 3:04:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[getColumnNames]
@tablename varchar(50)
as
select column_name from INFORMATION_SCHEMA.COLUMNS where table_name = @tablename