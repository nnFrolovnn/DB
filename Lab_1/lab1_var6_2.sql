use AdventureWorks2012;
go

/*
*  ������� �� ����� ������ �������, �������� ������� ���������� �� ����� �F� � ������������� �� ����� ��.
*/
select d.DepartmentID, d.Name 
from HumanResources.Department as d
where d.Name like 'F%e';
go

/*
*  ������� �� ����� ������� ���������� ����� ������� � ������� ���������� ���������� ����� � �����������. 
*  �������� ������� � ������������ �AvgVacationHours� � �AvgSickLeaveHours� ��� �������� � ���������� 
*  ��������������.
*/
select AVG(e.VacationHours) 'AvgVacationHours', AVG(e.SickLeaveHours) 'AvgSickLeaveHours'
from HumanResources.Employee as e;
go

/*
*  ������� �� ����� �����������, ������� ������ 65-�� ��� �� ��������� ������. 
*  ������� ����� ���������� ���, ��������� � ������� ���������������, � ������� � ������ �YearsWorked�.
*/
select e.BusinessEntityID, e.JobTitle, e.Gender, DATEDIFF(YEAR, e.HireDate, CURRENT_TIMESTAMP) 'YearsWorked'
from HumanResources.Employee as e
where DATEDIFF(YEAR, e.BirthDate, CURRENT_TIMESTAMP) > 65;
go
