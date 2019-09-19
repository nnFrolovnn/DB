use AdventureWorks2012;
go

/*
*  ¬ывести на экран список отделов, названи€ которых начинаютс€ на букву СFТ и заканчиваютс€ на букву СеТ.
*/
select d.DepartmentID, d.Name 
from HumanResources.Department as d
where d.Name like 'F%e';
go

/*
*  ¬ывести на экран среднее количество часов отпуска и среднее количество больничных часов у сотрудников. 
*  Ќазовите столбцы с результатами СAvgVacationHoursТ и СAvgSickLeaveHoursТ дл€ отпусков и больничных 
*  соответственно.
*/
select AVG(e.VacationHours) 'AvgVacationHours', AVG(e.SickLeaveHours) 'AvgSickLeaveHours'
from HumanResources.Employee as e;
go

/*
*  ¬ывести на экран сотрудников, которым больше 65-ти лет на насто€щий момент. 
*  ¬ывести также количество лет, прошедших с момента трудоустройства, в столбце с именем СYearsWorkedТ.
*/
select e.BusinessEntityID, e.JobTitle, e.Gender, DATEDIFF(YEAR, e.HireDate, CURRENT_TIMESTAMP) 'YearsWorked'
from HumanResources.Employee as e
where DATEDIFF(YEAR, e.BirthDate, CURRENT_TIMESTAMP) > 65;
go
