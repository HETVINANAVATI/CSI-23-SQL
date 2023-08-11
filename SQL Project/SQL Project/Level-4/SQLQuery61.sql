select * from SubjectAllotments
select * from SubjectRequest
insert into SubjectRequest values(159103036,'PO1498')
exec trackAllocation
delete from SubjectAllotments where StudentId=159103037