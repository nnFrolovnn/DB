use AdventureWorks2012;
go

/*
 *������� �� ����� ����� ������ ���� ������ ������ ���������� � ������ ������. 
 *���� ������� ��� ������� ������.
*/
select d.Name, Min(e.HireDate) "StartDate" from HumanResources.Department as d 
inner join HumanResources.EmployeeDepartmentHistory as edh on(d.DepartmentID = edh.DepartmentID)
inner join HumanResources.Employee as e on e.BusinessEntityID = edh.BusinessEntityID
group by d.Name;
go

/*
 *������� �� ����� �������� ����� �����������, ���������� �� ������� �Stocker�. 
 *�������� �������� ���� ������� (Day � 1; Evening � 2; Night � 3).
*/
select e.BusinessEntityID, e.JobTitle, s.ShiftID "ShiftName" from HumanResources.Employee as e
inner join HumanResources.EmployeeDepartmentHistory as edh on e.BusinessEntityID = edh.BusinessEntityID
inner join HumanResources.Shift as s on s.ShiftID = edh.ShiftID
where e.JobTitle = 'Stocker';
go

/*
 *������� �� ����� ���������� ��� ���� �����������, � ��������� ������, � ������� ��� �������� � ��������� ������.
 *� �������� ������� ������� ���������� �������� ����� �and� ������ & (���������).
*/
select e.BusinessEntityID, replace(e.JobTitle, 'and', '&') "JobTitle", d.Name "DepName" from HumanResources.Employee as e
inner join HumanResources.EmployeeDepartmentHistory as edh on e.BusinessEntityID = edh.BusinessEntityID
inner join HumanResources.Department as d on d.DepartmentID = edh.DepartmentID
where edh.EndDate is null;
go