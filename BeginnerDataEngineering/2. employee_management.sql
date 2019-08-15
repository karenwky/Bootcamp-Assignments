DROP DATABASE IF EXISTS Company; 

CREATE DATABASE Company; 
USE Company; 

CREATE TABLE Departments (
    Code int PRIMARY KEY, 
    Name TEXT, 
    Budget REAL
); 

CREATE TABLE Employees (
    SSN int PRIMARY KEY, 
    Name TEXT, 
    LastName TEXT, 
    Department int NOT NULL, 
    FOREIGN KEY (Department) REFERENCES Departments(Code)
); 

INSERT INTO Departments VALUES (14, 'IT', 65000); 
INSERT INTO Departments VALUES (37, 'Accounting', 15000); 
INSERT INTO Departments VALUES (59, 'Human Resources', 240000); 
INSERT INTO Departments VALUES (77, 'Research', 55000); 

INSERT INTO Employees VALUES (123234877, 'Michael', 'Rogers', 14); 
INSERT INTO Employees VALUES (152934485, 'Anand', 'Manikutty', 14); 
INSERT INTO Employees VALUES (222364883, 'Carol', 'Smith', 37);
INSERT INTO Employees VALUES (326587417, 'Joe', 'Stevens', 37); 
INSERT INTO Employees VALUES (332154719, 'Mary-Anne', 'Foster', 14);
INSERT INTO Employees VALUES (332569843, 'George', 'ODonnell', 77); 
INSERT INTO Employees VALUES (546523478, 'John', 'Doe', 59); 
INSERT INTO Employees VALUES (631231482, 'David', 'Smith', 77); 
INSERT INTO Employees VALUES (654873219, 'Zacary', 'Efron', 59); 
INSERT INTO Employees VALUES (745685214, 'Eric', 'Goldsmith', 59); 
INSERT INTO Employees VALUES (845657245, 'Elizabeth', 'Doe', 14); 
INSERT INTO Employees VALUES (845657246, 'Kumar', 'Swamy', 14); 

/* 1. Select all the data of employees that work in department 37 or department 77. */
SELECT *
FROM Employees
WHERE Department = 37 OR Department = 77; 

/* 2. Select all the data of employees whose last name begins with an "S". */
SELECT * 
FROM Employees
WHERE LastName LIKE 'S%'; 

/* 3. Select the sum of all the departments' budgets. */
SELECT SUM(Budget)
FROM Departments; 

/* 4. Select the number of employees in each department (you only need to show the department code and the number of employees). */
SELECT Department, COUNT(SSN) AS Number_Of_Employee
FROM Employees
GROUP BY Department; 

/* 5. Select all the data of employees, including each employee's department's data. */
SELECT Employees.SSN, Employees.Name, Employees.LastName, Employees.Department AS DepartmentCode, Departments.Name AS DepartmentName, Departments.Budget
FROM Employees
INNER JOIN Departments ON Departments.Code = Employees.Department; 

/* 6. Select the name and last name of each employee, along with the name and budget of the employee's department. */
SELECT Employees.Name, Employees.LastName, Departments.Name AS DepartmentName, Departments.Budget
FROM Departments
INNER JOIN Employees ON Departments.Code = Employees.Department; 

/* 7. Select the name and last name of employees working for departments with a budget greater than $60,000. */
SELECT Employees.Name, Employees.LastName
FROM Departments
INNER JOIN Employees ON Departments.Code = Employees.Department
WHERE Departments.Budget > 60000
ORDER BY Employees.LastName; 

/* 8. Select the departments with a budget larger than the average budget of all the departments. */
SELECT Name
FROM Departments
WHERE Budget > (
  SELECT AVG(Budget)
  FROM Departments
); 

/* 9. Select the names of departments with more than two employees. */
SELECT Departments.Name, COUNT(Employees.SSN) AS NumberOfEmployee
FROM Employees
INNER JOIN Departments ON Departments.Code = Employees.Department
GROUP BY Employees.Department
HAVING NumberOfEmployee > 2; 

/* 10. Select the name and lastname of employees working for departments with second lowest budget. */
SELECT Employees.Name, Employees.LastName
FROM Employees
INNER JOIN Departments ON Departments.Code = Employees.Department
WHERE Departments.Code = (
  SELECT Code
  FROM Departments
  ORDER BY Budget ASC
  LIMIT 1, 1
); 

INSERT INTO Departments VALUES (11, 'Quality Assurance', 40000); 
INSERT INTO Employees VALUES (847219811, 'Mary', 'Moore', 11); 

/* 11. Delete from the table all employees who work in departments with a budget greater than or equal to $60,000. */
DELETE FROM Employees
WHERE Department IN (
  SELECT Code 
  FROM Departments
  WHERE Budget >= 60000
); 
