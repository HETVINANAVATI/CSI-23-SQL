USE [studentChangeRequest]
GO
/****** Object:  StoredProcedure [dbo].[trackAllocation]    Script Date: 7/28/2023 1:15:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[trackAllocation]
as
declare @Student_id varchar(9),@Subject_id varchar(9),@check integer=0,@checkId varchar(9)
declare allocatedCursor cursor for 
select StudentId,SubjectId from SubjectRequest
open allocatedCursor
fetch next from allocatedCursor into @Student_id,@Subject_id 
while @@FETCH_STATUS=0
begin
	set @check= (select count(StudentId) from SubjectAllotments where StudentId=@Student_id group by StudentId)
	if (@check is null)
		begin
		insert into SubjectAllotments values(@Student_id,@Subject_id,1)
		end
	else
		begin
		    set @checkId=(select SubjectId from SubjectAllotments where Is_valid=1 and StudentId=@Student_id and SubjectId=@Subject_id)
			if(@checkId <> @Subject_id or @checkId is null)
				begin
				update SubjectAllotments set Is_valid=0 where StudentId=@Student_id
				insert into SubjectAllotments values(@Student_id,@Subject_id,1)
				end
        end
delete from SubjectRequest where StudentId=@Student_id and SubjectId=@Subject_id
fetch next from allocatedCursor into @Student_id,@Subject_id
end
close allocatedCursor
deallocate allocatedCursor

