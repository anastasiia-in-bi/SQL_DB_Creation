--create DB
CREATE DATABASE Road_accidents WITH OWNER = postgres
    ENCODING = 'UTF8';
    
--create schema "Prod"
CREATE SCHEMA IF NOT EXISTS Prod AUTHORIZATION postgres;

--create table "Road_accidents"
CREATE TABLE Prod.Road_accidents (
    Accident_id SERIAL NOT NULL PRIMARY KEY,
    Traffic_violation_id int NOT NULL,
    Accident_severity_id int NOT NULL,
    Policeman_id int NOT NULL,
    Region_id int NOT NULL,
    City_id int NOT NULL,
    Address_id int NOT NULL,
    Slightly_Injured int NOT NULL,
    Seriously_Injured int NOT NULL,
    Killed int NOT NULL);

--create table "Traffic_violations"
CREATE TABLE Prod.Traffic_violations (
    Violation_id SERIAL NOT NULL PRIMARY KEY,
    Violation text NOT NULL);

--create table "Accidents_severities"
CREATE TABLE Prod.Accidents_severities (
    Accident_severity_id SERIAL NOT NULL PRIMARY KEY,
    Severity_description text NOT NULL);

--create table "Persons"
CREATE TABLE Prod.Persons (
    Person_id SERIAL NOT NULL PRIMARY KEY,
    Surname text NOT NULL,
    Name text NOT NULL,
    Patronymic text,
    Passport text NOT NULL,
    Date_of_birth date NOT null,
    Driver_licence_number int);

--create table "Regions"
CREATE TABLE Prod.Regions (
    Region_id int NOT NULL PRIMARY KEY,
    Region text NOT NULL);
   
--create table "Cities"
CREATE TABLE Prod.Cities(
    City_id serial NOT NULL PRIMARY KEY,
    City text NOT NULL);
   
--create table "Addresses"
CREATE TABLE Prod.Addresses(
    Address_id serial NOT NULL PRIMARY KEY,
    Address text NOT NULL);

--create table "Drivers_accidents"
CREATE TABLE Prod.Drivers_accidents (
    Accident_id int NOT NULL,
    Driver_id int NOT NULL);

--create table "Drivers"
CREATE TABLE Prod.Drivers (
    Driver_id int NOT NULL PRIMARY KEY,
    Person_id int NOT NULL,
    Licence_valid_from date NOT NULL,
    Licence_valid_till date NOT NULL);

--create table "Policemen"
CREATE TABLE Prod.Policemen (
    Policeman_id int NOT NULL PRIMARY KEY,
    Person_id int NOT NULL,
    rank text NOT NULL);
   
--create table "Vehicles_accidents"
CREATE TABLE Prod.Vehicles_accidents (
    Accident_id int NOT NULL,
    Vehicle_id int NOT NULL);

--create table "Vehicles"
CREATE TABLE Prod.Vehicles (
    Vehicle_id int NOT NULL PRIMARY KEY,
    Vehicle_registration_number char(10) NOT NULL,
    Vehicle_model text NOT NULL,
    Vehicle_color text NOT NULL,
    Vehicle_country_origin text NOT NULL);

--add constraint check to Accidents_severities table
ALTER TABLE Prod.Accidents_severities
    ADD CONSTRAINT Accidents_severities_c1 check (Severity_description in ('Fatal', 'Serious', 'Slight'));
   
--add fks to Road_accidents table
ALTER TABLE Prod.Road_accidents
    ADD CONSTRAINT Road_accidents_Traffic_violation_id_fkey1 FOREIGN KEY (Traffic_violation_id) REFERENCES Prod.Traffic_violations(Violation_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    ADD CONSTRAINT Road_accidents_Accident_severity_id_fkey2 FOREIGN KEY (Accident_severity_id) REFERENCES Prod.Accidents_severities(Accident_severity_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    ADD CONSTRAINT Road_accidents_Policeman_id_fkey3 FOREIGN KEY (Policeman_id) REFERENCES Prod.Policemen(Policeman_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    ADD CONSTRAINT Road_accidents_Region_id_fkey4 FOREIGN KEY (Region_id) REFERENCES Prod.Regions(Region_id) ON UPDATE CASCADE ON DELETE restrict,
    ADD CONSTRAINT Road_accidents_City_id_fkey5 FOREIGN KEY (City_id) REFERENCES Prod.Cities(City_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    ADD CONSTRAINT Road_accidents_Address_id_fkey6 FOREIGN KEY (Address_id) REFERENCES Prod.Addresses(Address_id) ON UPDATE CASCADE ON DELETE RESTRICT;

--add fk to Policemen table
ALTER TABLE Prod.Policemen
    ADD CONSTRAINT Policemen_Person_id_fkey1 FOREIGN KEY (Person_id) REFERENCES Prod.Persons(Person_id) ON UPDATE CASCADE ON DELETE RESTRICT;

--add constraint to Persons table
ALTER TABLE Prod.Persons
    ADD CONSTRAINT check_Date_of_birth check ( (ROUND((current_date-Date_of_birth)/365)) <= 100);

--add fk to Drivers_accidents
ALTER TABLE Prod.Drivers_accidents
    ADD CONSTRAINT Drivers_accidents_Accident_id_fkey1 FOREIGN KEY (Accident_id) REFERENCES Prod.Road_accidents(Accident_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    ADD CONSTRAINT Drivers_accidents_Driver_id_fkey2 FOREIGN KEY (Driver_id) REFERENCES Prod.Drivers(Driver_id) ON UPDATE CASCADE ON DELETE RESTRICT;

   --add constraint to Drivers table
ALTER TABLE Prod.Drivers
    ADD CONSTRAINT Drivers_Person_id_fc1 FOREIGN KEY (Person_id) REFERENCES Prod.Persons(Person_id) ON UPDATE CASCADE ON DELETE RESTRICT;
   
--add fk to Vehicles_accidents
ALTER TABLE Prod.Vehicles_accidents
    ADD CONSTRAINT Vehicles_accidents_Accident_id_fkey1 FOREIGN KEY (Accident_id) REFERENCES Prod.Road_accidents(Accident_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    ADD CONSTRAINT Vehicles_accidents_Vehicle_id_fkey2 FOREIGN KEY (Vehicle_id) REFERENCES Prod.Vehicles(Vehicle_id) ON UPDATE CASCADE ON DELETE RESTRICT;

--add pk to Drivers_accedents table
ALTER TABLE Prod.Drivers_accidents    
    ADD CONSTRAINT Drivers_accidents_combo_pk PRIMARY KEY (Accident_id, Driver_id);
   
--add pk to Vehicles_accedents table
ALTER TABLE Prod.Vehicles_accidents    
    ADD CONSTRAINT Vehicles_accidents_combo_pk PRIMARY KEY (Accident_id, Vehicle_id);
   
/*add two recordinds in each table
 */
--Data for Name: Regions; Type: TABLE DATA; Schema: prod; Owner: postgres
INSERT INTO Prod.Regions VALUES (36, 'Voronezh Region');
INSERT INTO Prod.Regions VALUES (78, 'Leningrad Region');

--Data for Name: Cities; Type: TABLE DATA; Schema: prod; Owner: postgres
INSERT INTO Prod.Cities (City) VALUES ('Voronezh');
INSERT INTO Prod.Cities (City) VALUES ('Saint-Petersburg');
   
--Data for Name: Addresses; Type: TABLE DATA; Schema: prod; Owner: postgres
INSERT INTO Prod.Addresses (Address) VALUES ('Voronezh street, dom 1');
INSERT INTO Prod.Addresses (Address) VALUES ('Saint-Petersburg street, dom 58');

--Data for Name: Persons; Type: TABLE DATA; Schema: prod; Owner: postgres
INSERT INTO Prod.Persons VALUES (01, 'Ivanov', 'Sergey', 'Ivanovich', '045624544', '1995-02-15', 0115);
INSERT INTO Prod.Persons VALUES (02, 'Zhirkov', 'Sergey', 'Vladimirovich', '056565894', '1996-05-31', 0561);

--Data for Name: Vehicles; Type: TABLE DATA; Schema: prod; Owner: postgres
INSERT INTO Prod.Vehicles VALUES (281, 'R336AM87', 'Ford Mondeo', 'White', 'USA');
INSERT INTO Prod.Vehicles VALUES (125, 'O186AR36', 'Toyota Rav4', 'Red', 'Japan');
INSERT INTO Prod.Vehicles VALUES (642, 'N186OP198', 'Toyota Rav4', 'Black', 'Japan');
INSERT INTO Prod.Vehicles VALUES (703, 'E565GH84', 'LADA Kalina', 'Purple', 'Russia');

--Data for Name: Traffic_violations; Type: TABLE DATA; Schema: prod; Owner: postgres
INSERT INTO Prod.Traffic_violations (Violation) VALUES ('Red light passage');
INSERT INTO Prod.Traffic_violations (Violation) VALUES ('Violation of the speed limit');

--Data for Name: Drivers; Type: TABLE DATA; Schema: prod; Owner: postgres
INSERT INTO Prod.Drivers VALUES (0256, 01, '2016-07-25', '2026-07-25');
INSERT INTO Prod.Drivers VALUES (0865, 02, '2017-05-03', '2027-05-03');

--Data for Name: Policemen; Type: TABLE DATA; Schema: prod; Owner: postgres
INSERT INTO Prod.Policemen VALUES (84, 01, 'Sergeant');
INSERT INTO Prod.Policemen VALUES (96, 02, 'Lieutenant');

--Data for Name: Accidents_severities; Type: TABLE DATA; Schema: prod; Owner: postgres
INSERT INTO Prod.Accidents_severities (Severity_description) VALUES ('Slight');
INSERT INTO Prod.Accidents_severities (Severity_description) VALUES ('Serious');
INSERT INTO Prod.Accidents_severities (Severity_description) VALUES ('Fatal');

--Data for Name: Road_accidents; Type: TABLE DATA; Schema: prod; Owner: postgres
INSERT INTO Prod.Road_accidents (Traffic_violation_id, Accident_severity_id, Policeman_id, Region_id, City_id, Address_id, Slightly_Injured, Seriously_Injured, Killed) 
VALUES (1, 1, 84, 36, 1, 1, 1, 0, 0);
INSERT INTO Prod.Road_accidents (Traffic_violation_id, Accident_severity_id, Policeman_id, Region_id, City_id, Address_id, Slightly_Injured, Seriously_Injured, Killed) 
VALUES (2, 3, 96, 78, 2, 1, 1, 0, 3);
  
--Data for Name: Drivers_accidents; Type: TABLE DATA; Schema: prod; Owner: postgres
INSERT INTO Prod.Drivers_accidents VALUES (1, 0256);
INSERT INTO Prod.Drivers_accidents VALUES (2, 0865);

--Data for Name: Vehicles_accidents; Type: TABLE DATA; Schema: prod; Owner: postgres
INSERT INTO Prod.Vehicles_accidents VALUES (1, 281);
INSERT INTO Prod.Vehicles_accidents VALUES (1, 125);
INSERT INTO Prod.Vehicles_accidents VALUES (2, 642);
INSERT INTO Prod.Vehicles_accidents VALUES (2, 703);

/*for the HW task ALTER 2 any tables, add a new not null date_ts field to them with a default value
*/
--Add not null date_ts field to Road_accidents table
ALTER TABLE Prod.Road_accidents ADD COLUMN date_ts timestamp with time zone DEFAULT now() NOT NULL;

--Add not null date_ts field to Policemen table
ALTER TABLE Prod.Policemen ADD COLUMN date_ts timestamp with time zone DEFAULT now() NOT NULL;
