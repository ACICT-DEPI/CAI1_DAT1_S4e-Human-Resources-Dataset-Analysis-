-- create data base
create database HR ;

-- use datbase
use HR ;

-- create table have same columns name in Human Resource csv file
create table employees (
    Employee_ID VARCHAR(50) PRIMARY KEY,
    Full_Name VARCHAR(100),
    Gender VARCHAR(10),
    State VARCHAR(50),
    City VARCHAR(50),
    Education_Level VARCHAR(50),
    Birthdate DATE,
    Age INT,
    Hiredate DATE,
    Termdate VARCHAR(50),
    Years_of_Service INT,
    Employee_Status VARCHAR(50),
    Department VARCHAR(50),
    Job_Title VARCHAR(50),
    Job_Level VARCHAR(50),
    Salary FLOAT ,
    Performance_Rating VARCHAR(100)
	);

select * from employees ;

--load data from csv file
BULK INSERT employees
FROM 'C:\Users\Work-Station\Desktop\Final project\3- answer question using sql\Updated_HumanResources.csv'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n', 
    FIRSTROW = 2
);

select * from employees ;


--Calculate Overall Average Salary
select avg(salary) as "Average Salary"
from employees ;

-- What is the average salary for each performance rating (Average Salary by Performance Rating)?
SELECT Performance_Rating, AVG(Salary) AS Average_Salary
FROM employees
GROUP BY Performance_Rating;

--Average Salary by Department:
SELECT Department , AVG(Salary) AS Avg_Salary 
FROM employees 
GROUP BY Department;

--Average Salary by Gender:
SELECT Gender , AVG(Salary) AS Avg_Salary 
FROM employees 
GROUP BY Gender;

--What is the average salary by job level?(Salary Distribution by Job Level)
SELECT Job_Level, AVG(Salary) AS Avg_Salary 
FROM employees 
GROUP BY Job_Level;


--How many employees are there in each department?
SELECT Department, COUNT(*) AS Number_of_Employees
FROM employees
GROUP BY Department;


--What is the average age of employees in each department? (Average Age by Department):
SELECT Department, AVG(Age) AS Avg_Age 
FROM employees 
GROUP BY Department;


--What is the average number of years of service by department? (Average Years of Service by Department) :
SELECT Department, AVG(Years_of_Service) AS Avg_Years_of_Service 
FROM employees 
GROUP BY Department;

--How many employees have been terminated? ( turnover rate)
SELECT (SELECT COUNT(*) FROM employees WHERE Employee_Status = 'Terminated') * 100.0 / (SELECT COUNT(*) FROM employees) AS Turnover_Rate ;

--What is the percentage of employees by performance rating? (Performance Rating Distribution) :
SELECT Performance_Rating, 
       COUNT(Employee_ID) * 100.0 / (SELECT COUNT(*) FROM employees) AS Percentage_of_Employees 
FROM employees 
GROUP BY Performance_Rating;

--What is the average salary for employees with excellent performance ratings?
SELECT AVG(Salary) AS Avg_Salary 
FROM employees 
WHERE Performance_Rating = 'Excellent';

--How many employees have a performance rating of 'Excellent' and earn above the average salary?
SELECT COUNT(Employee_ID) AS Excellent_Above_Avg_Salary
FROM employees 
WHERE Performance_Rating = 'Excellent' 
AND Salary > (SELECT AVG(Salary) FROM employees);

--Employee Distribution by Job Level:
SELECT Job_Level, 
       COUNT(Employee_ID) AS Number_of_Employees 
FROM employees 
GROUP BY Job_Level;


--How many employees are close to retirement? (Number of Employees Near Retirement)(age > 60):
SELECT COUNT(*) AS Near_Retirement 
FROM employees 
WHERE Age > 60;


--Percentage of Employees Near Retirement (age > 60):
SELECT 
    (SELECT COUNT(*) FROM employees WHERE Age > 60) * 100.0 / 
    (SELECT COUNT(*) FROM employees) AS Near_Retirement_Percentage;


--What is the average salary for employees with more than 5 years of service?
SELECT AVG(Salary) AS Avg_Salary 
FROM employees 
WHERE Years_of_Service > 5;

--What is the average performance rating by department?
SELECT Department, 
       AVG(CASE 
           WHEN Performance_Rating = 'Excellent' THEN 4
           WHEN Performance_Rating = 'Good' THEN 3
           WHEN Performance_Rating = 'Satisfactory' THEN 2
		   WHEN Performance_Rating = 'Need Improve' THEN 1
           ELSE 0 
       END) AS Avg_Performance_Score
FROM employees 
GROUP BY Department;

--How many employees are terminated within their first year of service?
SELECT COUNT(Employee_ID) AS Terminated_In_First_Year 
FROM employees 
WHERE DATEDIFF(YEAR, Hiredate , Termdate) <= 1 
AND Employee_Status = 'Terminated';

--What is the distribution of employees' education levels?
SELECT Education_Level, 
       COUNT(*) AS Number_of_Employees 
FROM employees 
GROUP BY Education_Level;

--What is the gender distribution in each department?
SELECT Department, 
       Gender, 
       COUNT(Employee_ID) AS Number_of_Employees 
FROM employees 
GROUP BY Department , Gender
ORDER BY Department;

--What percentage of employees are within each performance rating category?
SELECT Performance_Rating, 
       COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employees) AS Percentage 
FROM employees 
GROUP BY Performance_Rating;

--What is the gender distribution across the company?
SELECT Gender, COUNT(*) AS Number_of_Employees 
FROM employees 
GROUP BY Gender;

--What is the average age of employees in each department?
SELECT Department, AVG(Age) AS Avg_Age 
FROM employees 
GROUP BY Department;

--What is the average age of employees by job title?
SELECT Job_Title, AVG(Age) AS Avg_Age 
FROM employees 
GROUP BY Job_Title;

--What are the most influential factors affecting turnover rates?
SELECT Employee_Status, 
       AVG(Salary) AS Avg_Salary, 
       AVG(Age) AS Avg_Age, 
       AVG(Years_of_Service) AS Avg_Years_of_Service 
FROM employees 
GROUP BY Employee_Status;

--How can we predict future performance based on current data?
SELECT Performance_Rating, 
       AVG(Salary) AS Avg_Salary, 
       AVG(Years_of_Service) AS Avg_Years_of_Service, 
       AVG(Age) AS Avg_Age 
FROM employees 
GROUP BY Performance_Rating;

--What are the trends in performance ratings over time?
SELECT YEAR(Hiredate) AS Year, 
       Performance_Rating, 
       COUNT(Employee_ID) AS Number_of_Employees 
FROM employees 
GROUP BY YEAR(Hiredate), Performance_Rating
ORDER BY Year, 
         CASE Performance_Rating
             WHEN 'Excellent' THEN 1
             WHEN 'Good' THEN 2
             WHEN 'Satisfactory' THEN 3
             WHEN 'Need Improvement' THEN 4
             ELSE 5 
         END;

--Is there a correlation between employee performance and age or years of service?
SELECT Performance_Rating, 
       AVG(Age) AS Avg_Age, 
       AVG(Years_of_Service) AS Avg_Years_of_Service 
FROM employees 
GROUP BY Performance_Rating;

--What is the percentage of employees in each state?
SELECT State, COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employees) AS Percentage_of_Employees
FROM employees
GROUP BY State 
ORDER BY State;

--What is the percentage of employees by gender in each performance rating?
SELECT  Gender, Performance_Rating, COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employees) AS Percentage_of_Employees
FROM employees
GROUP BY Gender, Performance_Rating
ORDER BY Gender , CASE Performance_Rating
             WHEN 'Excellent' THEN 1
             WHEN 'Good' THEN 2
             WHEN 'Satisfactory' THEN 3
             WHEN 'Need Improvement' THEN 4
             ELSE 5 
         END;

--How many employees have been hired in the last three years?
SELECT COUNT(*) AS Number_of_Employees_Hired
FROM employees
WHERE Hiredate >= DATEADD(YEAR, -3, GETDATE());

--How does education level affect salaries?
SELECT Education_Level, AVG(Salary) AS Average_Salary
FROM employees
GROUP BY Education_Level;

--Turnover Rate by Year:
SELECT  YEAR(Hiredate) AS Year,COUNT(CASE WHEN Employee_Status = 'Terminated' THEN 1 END) AS Terminated_Count,
COUNT(*) AS Total_Employees, COUNT(CASE WHEN Employee_Status = 'Terminated' THEN 1 END) * 100.0 / COUNT(*) AS Turnover_Rate
FROM employees
GROUP BY YEAR(Hiredate)
ORDER BY Year;
