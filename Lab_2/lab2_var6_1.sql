use AdventureWorks2012;
go

/*
 *¬ывести на экран самую раннюю дату начала работы сотрудника в каждом отделе. 
 *ƒату вывести дл€ каждого отдела.
*/
select d.Name, Min(e.HireDate) "StartDate" from HumanResources.Department as d 
inner join HumanResources.EmployeeDepartmentHistory as edh on(d.DepartmentID = edh.DepartmentID)
inner join HumanResources.Employee as e on e.BusinessEntityID = edh.BusinessEntityID
group by d.Name;
go

/*
 *¬ывести на экран название смены сотрудников, работающих на позиции СStockerТ. 
 *«амените названи€ смен цифрами (Day Ч 1; Evening Ч 2; Night Ч 3).
*/
select e.BusinessEntityID, e.JobTitle, s.ShiftID "ShiftName" from HumanResources.Employee as e
inner join HumanResources.EmployeeDepartmentHistory as edh on e.BusinessEntityID = edh.BusinessEntityID
inner join HumanResources.Shift as s on s.ShiftID = edh.ShiftID
where e.JobTitle = 'Stocker';
go

/*
 *¬ывести на экран информацию обо всех сотрудниках, с указанием отдела, в котором они работают в насто€щий момент.
 *¬ названии позиции каждого сотрудника заменить слово СandТ знаком & (амперсанд).
*/
select e.BusinessEntityID, replace(e.JobTitle, 'and', '&') "JobTitle", d.Name "DepName" from HumanResources.Employee as e
inner join HumanResources.EmployeeDepartmentHistory as edh on e.BusinessEntityID = edh.BusinessEntityID
inner join HumanResources.Department as d on d.DepartmentID = edh.DepartmentID
where edh.EndDate is null;
go