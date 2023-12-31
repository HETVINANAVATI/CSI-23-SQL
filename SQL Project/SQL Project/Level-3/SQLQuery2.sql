USE [studentallocation]
GO
/****** Object:  StoredProcedure [dbo].[allotelectiveandtracknonallocated]    Script Date: 7/27/2023 11:42:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[allotelectiveandtracknonallocated]
as
declare @Student_id int,@Student_name varchar(50),@GPA decimal(2,1),@Branch varchar(3),@Section char,@rem int,@preference int,@increament int=1,@subject_id varchar(6),@check int,@done int
declare detailsCursor cursor for 
select Student_id,Student_name,GPA,Branch,Section from student_Details order by GPA desc
open detailsCursor
fetch next from detailsCursor into @Student_id,@Student_name,@GPA,@Branch,@Section
while @@FETCH_STATUS=0
begin
set @preference=(select count(SubjectId) from SubjectDetails)
set @increament=1
	while @increament<= @preference
	begin
	set @subject_id=(select  SubjectId from StudentPreference where StudentId=@Student_id and Preference=@increament) 
	set @rem = (select RemainingSeats from SubjectDetails where SubjectId=@subject_id)
	if (@rem>0)
		begin
		
		set @check=(select count(StudentId) from Allotments where StudentId=@Student_id)
		if(@check=0)
		  begin
		  update SubjectDetails set RemainingSeats=RemainingSeats-1 where SubjectId =@subject_id
		  set @increament=@preference+1
		  insert into allotments values(@subject_id,@Student_id)
		  end
		  else
		   begin
		   set @increament=@preference+1
		   end
		 end
	 else
		begin
		set @increament=@increament+1
		end
	end
	set @check=(select count(@Student_id) from allotments)
	if(@check=0)
	begin
		insert into unallotedStudents values(@Student_id)
    end
	fetch next from detailsCursor into @Student_id,@Student_name,@GPA,@Branch,@Section
end
close detailsCursor
deallocate detailsCursor

