use AdventureWorks2012;
go

drop function if exists Sales.CalculateTotalPrice;
go

/*
 *Создайте scalar-valued функцию, которая будет принимать в качестве входного параметра 
 *id заказа (Sales.SalesOrderHeader.SalesOrderID) и 
 *возвращать итоговую сумму для заказа (сумма по полям SubTotal, TaxAmt, Freight).
*/
create function Sales.CalculateTotalPrice(@SalesOrderID int)
returns money
as
begin
	return (select (SUM(so.SubTotal) + SUM(so.TaxAmt) + SUM(so.Freight))
			from Sales.SalesOrderHeader as so
			where so.SalesOrderID = @SalesOrderID);
end;
go

drop function if exists Production.GetOrderDetailsByID;
go

/*
 *Создайте inline table-valued функцию, которая будет принимать в качестве входного параметра 
 *id заказа на производство (Production.WorkOrder.WorkOrderID), а возвращать детали заказа из 
 *Production.WorkOrderRouting.
*/
create function Production.GetOrderDetailsByID(@WorkOrderID int)
returns table as return (
	select 
		WorkOrderID,
		ProductID,
		OperationSequence,
		LocationID,
		ScheduledStartDate,
		ScheduledEndDate,
		ActualStartDate,
		ActualEndDate,
		ActualResourceHrs,
		PlannedCost,
		ActualCost,
		ModifiedDate
	from Production.WorkOrderRouting
	where Production.WorkOrderRouting.WorkOrderID = @WorkOrderID		
);
go

/*
 *Вызовите функцию для каждого заказа, применив оператор CROSS APPLY. 
 *Вызовите функцию для каждого заказа, применив оператор OUTER APPLY.
*/
select * from Sales.SalesOrderHeader CROSS APPLY (select Sales.CalculateTotalPrice(SalesOrderID) 'Total price') as tp;
select * from Sales.SalesOrderHeader OUTER APPLY (select Sales.CalculateTotalPrice(SalesOrderID) 'Total price') as tp;
go

select * from Production.WorkOrder CROSS APPLY Production.GetOrderDetailsByID(WorkOrderID);
select * from Production.WorkOrder OUTER APPLY Production.GetOrderDetailsByID(WorkOrderID);
go

drop function if exists Production.GetOrderDetailsByID;
go

/*
 *Измените созданную inline table-valued функцию, сделав ее multistatement table-valued 
 *(предварительно сохранив для проверки код создания inline table-valued функции).
*/
create function Production.GetOrderDetailsByID(@WorkOrderID int)
returns @result table(
	WorkOrderID int not null,
    ProductID int not null,
    OperationSequence smallint not null,
    LocationID smallint not null,
    ScheduledStartDate datetime not null,
    ScheduledEndDate datetime not null,
    ActualStartDate datetime null,
    ActualEndDate datetime null,
    ActualResourceHrs decimal(9, 4) null,
    PlannedCost money not null,
    ActualCost money null,
    ModifiedDate datetime not null
) as begin
	insert into @result
	select 
		WorkOrderID,
		ProductID,
		OperationSequence,
		LocationID,
		ScheduledStartDate,
		ScheduledEndDate,
		ActualStartDate,
		ActualEndDate,
		ActualResourceHrs,
		PlannedCost,
		ActualCost,
		ModifiedDate
	from Production.WorkOrderRouting
	where Production.WorkOrderRouting.WorkOrderID = @WorkOrderID
	return
end;