CREATE PROCEDURE InsertAndTruncateDataWithTableName
    @sourceTableName NVARCHAR(128),
    @targetTableName NVARCHAR(128),
    @columnsList NVARCHAR(MAX)
AS
BEGIN
    DECLARE @insertQuery NVARCHAR(MAX);
    DECLARE @truncateQuery NVARCHAR(MAX);
    
    SET @insertQuery = N'INSERT INTO ' + QUOTENAME(@targetTableName) + ' (' + @columnsList + N') SELECT ' + @columnsList + N' FROM ' + QUOTENAME(@sourceTableName) + ';';
    SET @truncateQuery = N'TRUNCATE TABLE ' + QUOTENAME(@sourceTableName) + ';';
    
   
    EXEC sp_executesql @insertQuery;
    
    
    EXEC sp_executesql @truncateQuery;
END;
