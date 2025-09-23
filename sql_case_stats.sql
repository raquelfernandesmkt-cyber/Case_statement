-- 1.1 retrieve all data from the table 
select* 
from employees; 

-- 1.2 Change M to Male and F to Female 
select 
emp_no, first_name, last_name, 
case 
  when gender is = 'M' then 'Male'
  else 'Female' 
end
from employees; 

-- 1.3 same result as 1.2 
select 
emp_no, first_name, last_name, 
case 
  when gender is = 'M' then 'Male'
  else 'Female' 
end as gender 
from employees; 

-- 1.4 same result as 1.2 and 1.3
select 
emp_no, first_name, last_name, 
case gender
  when 'M' then 'Male'
  else 'Female' 
end as gender 
from employees; 

-- 2.1 retrieve all data from the table 
select * from customers; 

-- 2.2 create a column called Age_category that retuns Young for ages less than 30, 
-- Aged for ages greater than 60, and Middle Aged otherwise 
select *, 
case 
  when age < 30 then 'Young'
  when age > 60 then 'Aged' 
  else 'Middle Aged'
end as Age_Category
from customers; 

-- 2.3 retrieve a list of the number of employees that were employed before 1990, between 1990 and 1995 and after 1995
select 
  emp_no, hire_date, EXTRACT(YEAR FROM hire_date) as year, 
  case 
    when EXTRACT(YEAR FROM hire_date) < '1990' then 'employed before 1990'
    when EXTRACT (YEAR FROM hire_date) >= '1990' and EXTRACT (YEAR FROM hire_date) < = '1995' then 'employed between 1990 and 1995'
    else 'employed after 1995'
end as emp_date
from employees; 

-- 3.1 retrieve the average salary of all employees 
select * from salaries; 

select emp_no, avg (salary) 
from salaries
group by emp_no
order by avg (salary) desc; 

-- 3.2 retrieve a list of the avg salary of employees. If the avg salary is more than 80000, return Paid well. 
-- If the avg salary is less then 80000, return underpaid. Otherwise, return unpaid 

select emp_no, round (avg (salary),3) as average_salary 
case 
  when avg (salary) > 80000 then 'Paid Well'
  when avg (salary < 80000 then 'Underpaid'
  else 'Unpaid' 
  end as salary_category 
from salaries 
  group by emp_no
  order by average_salary desc; 

-- 3.3 retrieve a list of avg salary of employees. If the avg salary is more than 80000 but less then 100000, return paid well
-- If the avg salary is less than 80000, return underpaid, otherwise, return manager 

select emp_no, round (avg (salary),3) as average_salary 
case 
  when avg (salary) > 80000 and avg (salary) < 100000then 'Paid Well'
  when avg (salary < 80000 then 'Underpaid'
  else 'Manager' 
  end as salary_category 
from salaries 
  group by emp_no
  order by average_salary desc; 

-- 3.4 count the number of employees in each salary category 
select a.salary_category, count (*)
  from (
select emp_no, round (avg (salary),3) as average_salary 
case 
  when avg (salary) > 80000 and avg (salary) < 100000then 'Paid Well'
  when avg (salary < 80000 then 'Underpaid'
  else 'Manager' 
  end as salary_category 
from salaries 
  group by emp_no
  order by average_salary desc) a 
  group by a.salary_category; 

-- 4.1 Retrieve all the data from the employess and dept_manager tables 
select * from employees 
order by emp_no desc; 

select * from dept_manager; 

-- 4.2 join all the records in the employees table to the dept_manager table (e is the left table - dm is the right table) 
select e.emp_no, dm.emp_no, e.first_name, e.last_name
from employees as e 
left join dept_manager as dm 
on dm.emp_no = e.emp_no
order by dm.emp_no; 

-- 4.3 join all the records in the employees table to the dept_manager table (e is the left table - dm is the right table) 
-- where the employee number is greater then 109990
select e.emp_no, dm.emp_no, e.first_name, e.last_name
from employees as e 
left join dept_manager as dm 
on dm.emp_no = e.emp_no
where e.emp_no > 109990;

-- 4.4 obtain a result set containing the employee number, first name, and last name of all employees. 
-- Create a 4th column in the query, indicating whether this employee is also a manager, according to the data in the 
-- dept_manager table, or a regular employee 
select e.emp_no, e.first_name, e.last_name
  case 
    when dm.emp_no is not null then 'manager'
    else 'employee'
  end as is_manager
from employees as e 
left join dept_manager as dm 
on dm.emp_no = e.emp_no
order by dm.emp_no; 

-- 4.5 Obtain a result set containing the employee number, first name, and last name of all employee wiht a number greater than '109990'. 
-- Create a 4th column in the query, indicating whether this employee is also a manager, according to the data in the dept_manager table, or a regular employee 
select e.emp_no, e.first_name, e.last_name
  case 
    when dm.emp_no is not null then 'manager'
    else 'employee'
  end as is_manager
from employees as e 
left join dept_manager as dm 
on dm.emp_no = e.emp_no
where the emp_no > 109990 
order by dm.emp_no; 

-- 5.1 retrieve all the data from the employee and salaries tables
select * from employees; 

-- 5.2 retrieve a list of all salaries earned by an employee
select e.emp_no, e.first_name, e.last_name, s.salary 
from employees as e 
join salaries as s  --- as known as inner join, it will bring result from both table even if there is not a match 
on e.emp_no = s.emp_no; 

-- 5.3 retrieve a list of employee number, first name, last name. Add a column called 'salary difference' which is the difference between the employees' max and min salary. 
-- also, add a column called 'salary increase', which returns 'Salary was raised by more than $30,000' if the difference is more than $30,000, 'Salary was raised by more than
-- $20,000 but less then $30,000, if the difference is between $20,00 and $30,000, 'Salary was raised by less then $20,000' if the difference is less than $20,000 
select e.emp_no, e.first_name, e.last_name, MAX (s.salary) - MIN (s.salary) as salary_difference, 
case 
  when max (s.salary) - min (s.salary) > 30000 then 'salary was raised by more than $30,000'
  when mas (s.salary) - min (s.salary) between 20000 and 30000 then 'salary was raised by more than $20,000 but less than $30,000'
  else 'salary was raised by less than $20,000' 
end as slry_increase 
from employees as e 
join salaries as s 
on e.emp_no = s.emp_no; 



