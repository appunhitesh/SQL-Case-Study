-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
   OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'C:\Users\admin\Documents\Projects\SQL_Projects\Books.csv' 
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'C:\Users\admin\Documents\Projects\SQL_Projects\Customer.csv' 
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'C:\Users\admin\Documents\Projects\SQL_Projects\Order.csv' 
CSV HEADER;


--  Retrieve all books in the "Fiction" genre

select * from books 
where Genre = 'Fiction';

-- Find books published after the year 1950

select * from books 
where Published_Year > 1950;

-- List all customers from the Canada

select name as CustomerName,Country from customer
where Country = 'Canada';

-- Show orders placed in November 2023

select * from orders 
where Order_date between '2023-11-01' and '2023-11-30';

-- Retrieve the total stock of books available

select sum(Stock) as Total_Stock from books;

-- Find the details of the most expensive book

select * from books
where Price = (select max(Price) from books);

-- Show all customers who ordered more than 1 quantity of a book

select Name as CustomerName , o.Quantity as QTY from customer c 
join orders o on o.Customer_ID = c.Customer_ID
where o.Quantity > 1;

-- Retrieve all orders where the total amount exceeds $20

select * from orders 
where Total_Amount > 20;

-- List all genres available in the Books table

select distinct genre from books;

-- Find all the book with the lowest stock

select * from books 
where Stock = (select min(Stock) from books);

-- Calculate the total revenue generated from all orders

select sum(Total_Amount) as Total_Revenue from orders;

-- Retrieve the total number of books sold for each genre

select genre ,sum(o.Quantity) as Total_sold from books b 
join orders o on o.Book_ID = b.Book_ID 
group by genre
order by Total_sold desc;

-- Find the average price of books in the "Fantasy" genre

select avg(Price) as Average_Price from books
where genre = 'Fantasy';

-- List customers who have placed at least 2 orders

select Name , c.Customer_ID , count(Order_ID) as Total_Orders from customer c 
join orders o on o.Customer_ID = c.Customer_ID
group by Name, c.Customer_ID
having count(Order_ID) > 1
order by Total_Orders desc;

-- Find the most frequently ordered book

select Title as Book_Name, b.Book_ID , o.Order_Date from books b 
join orders o on o.Book_ID = b.Book_ID
order by Order_Date desc;

-- Show the top 3 most expensive books of 'Fantasy' Genre

select Title , Price from books 
where genre = 'Fantasy'
order by  Price desc
limit 3;

-- Retrieve the total quantity of books sold by each author

select Author , sum(Quantity) as Total_QTY from books b 
join orders o on o.Book_ID = b.Book_ID
group by Author
order by Total_QTY desc;

-- List the cities where customers who spent over $30 are located

select distinct City from customer c 
join orders o on o.Customer_ID = c.Customer_ID
where o.Total_Amount > 30;

-- Find the customer who spent the most on orders

select Name , c.Customer_ID , sum(Total_Amount) as Total_Spent from customer c 
join orders o on o.Customer_ID = c.Customer_ID
group by Name , c.Customer_ID
order by Total_Spent desc;

-- Calculate the stock remaining after fulfilling all order

select Title as Book_Title , Stock as Presold_Stock, coalesce(o.Quantity,0) as Quantity_Sold, coalesce((Stock - o.Quantity),0) as Stock_Available from books b 
left join orders o on o.Book_ID = b.Book_ID
where coalesce((Stock - o.Quantity),0) >= 0 
order by Stock_Available desc;










