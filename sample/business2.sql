# this sample ist taken from publication:
# Roger H.L. Chiang; Terence M. Barron; Veda C. Storey. 
# Reverse engineering of relational databases: 
# Extraction of an EER model from a relational database.  
# Data \& Knowledge Engineering 12. Elsevier. 1994. Seiten 107-142.
#
# Some Changes are make for compatibility
# SQL Commands to create an example database for MySQL RDBMS
# 
CREATE TABLE Person (
  SSN int DEFAULT '0' NOT NULL auto_increment,
  name varchar(20),
  address varchar(25),
  PRIMARY KEY (SSN)
);
CREATE TABLE Employee (
  SSN int NOT NULL,
  name varchar(20),
  salary int,
  hired_date date,
  PRIMARY KEY (SSN)
);
CREATE TABLE Manager (
  SSN int NOT NULL,
  rank int,
  promotion_date date,
  DEPTNO int,
  PRIMARY KEY (SSN)
);
CREATE TABLE Customer (
  CUSTID int DEFAULT '0' NOT NULL auto_increment,
  name varchar(20),
  credit int,
  PRIMARY KEY (CUSTID)
);
CREATE TABLE Departament (
  DEPTNO int DEFAULT '0' NOT NULL auto_increment,
  dept_name varchar(20),
  location varchar(20),
  PRIMARY KEY (DEPTNO)
);
CREATE TABLE Product (
  PRODID int DEFAULT '0' NOT NULL auto_increment,
  description varchar(20),
  PRIMARY KEY (PRODID)
);
CREATE TABLE Price (
  PRODID int NOT NULL,
  minprice int,
  maxprice int,
  PRIMARY KEY (PRODID)
);
CREATE TABLE CusOrder (
  ORDID int DEFAULT '0' NOT NULL auto_increment,
  order_date date,
  PRODID int,
  CUSTID int,
  PRIMARY KEY (ORDID)
);
CREATE TABLE Carrier (
  CARRIERID int DEFAULT '0' NOT NULL auto_increment,
  name varchar(20),
  address varchar(20),
  PRIMARY KEY (CARRIERID)
);
CREATE TABLE Project (
  PROJNAME varchar(20) NOT NULL,
  DEPTNO int NOT NULL,
  budget int,
  PRIMARY KEY (PROJNAME,DEPTNO)
);
CREATE TABLE Work_for (
  SSN int NOT NULL,
  DEPTNO int NOT NULL,
  start_data date,
  PRIMARY KEY (SSN,DEPTNO)
);
CREATE TABLE Can_produce (
  DEPTNO int NOT NULL,
  PRODID int NOT NULL,
  unit_cost int,
  PRIMARY KEY (PRODID,DEPTNO)
);
CREATE TABLE Shipment (
  PACKID int  DEFAULT '0' NOT NULL auto_increment,
  ORDID int NOT NULL,
  ship_date date,
  CARRIERID int,
  unit_cost int,
  PRIMARY KEY (PACKID,ORDID)
);
