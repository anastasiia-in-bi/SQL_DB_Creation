/*Add 3 of your favorite films to the table film c rental rate 4.99, 9.99 and 19.99 and rental
durations 1, 2 and 3 weeks respectively*/
--Data for Name: film; Type: TABLE DATA; Schema: public; Owner: postgres
INSERT INTO film (title, description, release_year, language_id, original_language_id, rental_duration, length) 
VALUES ('GONE WITH THE WIND', 'A manipulative woman and a roguish man conduct a turbulent romance during the American Civil War and Reconstruction periods.',
1939, 
(select language_id from language 
where upper(name)='ENGLISH'),
(select language_id from language 
where upper(name)='ENGLISH'),
1, 238);
    
INSERT INTO film (title, description, release_year, language_id, original_language_id, rental_duration, rental_rate, length) 
VALUES ('DELICATESSEN', 'Post-apocalyptic surrealist black comedy about the landlord of an apartment building who occasionally prepares a delicacy for his odd tenants.',
1991, 
(select language_id from language 
where upper(name)='ENGLISH'),
(select language_id from language 
where upper(name)='FRENCH'),
2, 9.99, 99);

INSERT INTO film (title, description, release_year, language_id, original_language_id, rental_rate, length) 
VALUES ('LA FILLE DU 14 JUILLET', 'Hector, who met Truquette at the Louvre on July 14, has only one concern since then: seduce this girl. The best way to do so is by taking her to the sea. Pator, his friend, is accompanying him along with Truquette_s girlfriend, Charlotte.',
2013, 
(select language_id from language 
where upper(name)='ENGLISH'),
(select language_id from language 
where upper(name)='FRENCH'),
19.99, 88);

/*add the stars of these films to the actor and film_actor tables (at least 6 in total)*/
--Data for Name: actor; Type: TABLE DATA; Schema: public; Owner: postgres
INSERT INTO actor (first_name, last_name)
VALUES ('PASCAL', 'BENEZEK');

INSERT INTO actor (first_name, last_name)
VALUES ('DOMINIC', 'PINON');

INSERT INTO actor (first_name, last_name)
VALUES ('GREGORY', 'TACHNAKIAN');

INSERT INTO actor (first_name, last_name)
VALUES ('VINCENT', 'MACAIGNE');

INSERT INTO actor (first_name, last_name)
VALUES ('CLARK', 'GABLE');

INSERT INTO actor (first_name, last_name)
VALUES ('VIVIEN', 'LEIGH');

INSERT INTO actor (first_name, last_name)
VALUES ('THOMAS', 'MITCHELL');

--Data for Name: film_actor; Type: TABLE DATA; Schema: public; Owner: postgres
INSERT INTO film_actor (actor_id, film_id) 
select * from (
    select (select actor_id from actor
    where first_name = 'DOMINIC' and last_name = 'PINON'),
    film_id from film 
    where title = 'DELICATESSEN'
    union
    select (select actor_id from actor
    where first_name = 'PASCAL' and last_name = 'BENEZEK'),
    film_id from film 
    where title = 'DELICATESSEN'
    union
    select (select actor_id from actor
    where first_name = 'GREGORY' and last_name = 'TACHNAKIAN'),
    film_id from film 
    where title = 'LA FILLE DU 14 JUILLET'
    union
    select (select actor_id from actor
    where first_name = 'VINCENT' and last_name = 'MACAIGNE'),
    film_id from film 
    where title = 'LA FILLE DU 14 JUILLET'
    union
    select (select actor_id from actor
    where first_name = 'CLARK' and last_name = 'GABLE'),
    film_id from film 
    where title = 'GONE WITH THE WIND'
    union
    select (select actor_id from actor
    where first_name = 'VIVIEN' and last_name = 'LEIGH'),
    film_id from film 
    where title = 'GONE WITH THE WIND'
    union
    select (select actor_id from actor
    where first_name = 'THOMAS' and last_name = 'MITCHELL'),
    film_id from film 
    where title = 'GONE WITH THE WIND'
    ) as t1;
   
/*Add my favorite movies to store's inventory*/
--check the existing stores
select * from store 

--Add my favorite movies to store's inventory
INSERT INTO inventory (film_id, store_id) 
select * from (
    SELECT film_id, 1 FROM film WHERE title = upper('GONE WITH THE WIND')
    UNION 
    SELECT film_id, 1 FROM film WHERE title = upper('DELICATESSEN')
    UNION 
    SELECT film_id, 2 FROM film WHERE title = upper('LA FILLE DU 14 JUILLET')) as t1;

/*Change the personal data of all clients (name, surname) who rented
films not less than 43 times and paid for them at least 43 times on their own*/
UPDATE customer
SET first_name = 'IVAN', last_name = 'IVANOV'
WHERE customer_id in (
    select customer_id
    from rental 
    where customer_id in (
        select customer_id
        from payment
        group by customer_id
        having count(payment_id)>=43) 
    group by customer_id
    having count(rental_id)>=43
    limit 1); --limit 1 in order to change only 1 recording, not 515

/*Rent and pay for your favorite movies (add records to tables to reflect
this activity)*/

--add St.Petersburg as a city as it is missed there
insert into city (city, country_id)  
values ('St.Petersburg', (
select country_id 
from country 
where upper(country)='RUSSIAN FEDERATION'));

--add address of mine (not real, just for the task)
insert into address (address, district, city_id, postal_code, phone)  
values ('46-4 Kosygina prospekt', 'St.Petersburg', (
select city_id 
from city
where city='St.Petersburg'), 193365, 8654568566554);
  
--add new customer 
INSERT INTO customer (customer_id, store_id, first_name, last_name, address_id) 
VALUES ((
    select max(customer_id) +1
    from customer),
1,'ANASTASIIA', 'BATALOVA', (
    select address_id from address
    where address='46-4 Kosygina prospekt'));
  
--rent films Delicatessen, La fille du 14 juillet, Gone with the Wind
insert into rental (rental_id, rental_date, inventory_id, customer_id, staff_id)  
select * from (
    select (
    select max(rental_id) +1
    from rental),
now(),
    (select inventory_id
    from inventory
    where film_id in(
        select film_id from film 
        where title = 'GONE WITH THE WIND')),
   (select customer_id from customer
    where first_name = 'ANASTASIIA'
    and last_name = 'BATALOVA'),
1
union 
 select (
    select max(rental_id) +2
    from rental),
now(),
    (select inventory_id
    from inventory
    where film_id in(
        select film_id from film 
        where title = 'DELICATESSEN')),
   (select customer_id from customer
    where first_name = 'ANASTASIIA'
    and last_name = 'BATALOVA'),
1
union 
 select (
    select max(rental_id) +3
    from rental),
now(),
    (select inventory_id
    from inventory
    where film_id in(
        select film_id from film 
        where title = 'LA FILLE DU 14 JUILLET')),
   (select customer_id from customer
    where first_name = 'ANASTASIIA'
    and last_name = 'BATALOVA'),
1) as t1;

--pay for the rents
CREATE TABLE payment_p2021_01 PARTITION OF payment
    FOR VALUES FROM ('2021-01-01 00:00:00+3:00') TO ('2021-12-31 00:00:00+3:00');

--payments insert altogether for 3 films
insert into payment (customer_id, staff_id, rental_id, amount, payment_date)
select * from (
    select (select customer_id from customer
    where first_name = 'ANASTASIIA'
    and last_name = 'BATALOVA'),
1, 
    (select rental_id from rental
    where inventory_id = (
        select inventory_id
        from inventory
        where film_id in(
            select film_id from film 
            where title = 'LA FILLE DU 14 JUILLET')) 
        and
        customer_id in (select customer_id from customer
        where first_name = 'ANASTASIIA'
        and last_name = 'BATALOVA')),
2.29, current_timestamp
union 
select (select customer_id from customer
    where first_name = 'ANASTASIIA'
    and last_name = 'BATALOVA'),
1, 
    (select rental_id from rental
    where inventory_id = (
        select inventory_id
        from inventory
        where film_id in(
            select film_id from film 
            where title = 'DELICATESSEN')) 
        and
        customer_id in (select customer_id from customer
        where first_name = 'ANASTASIIA'
        and last_name = 'BATALOVA')),
1.29, current_timestamp    
union 
select (select customer_id from customer
    where first_name = 'ANASTASIIA'
    and last_name = 'BATALOVA'),
1, 
    (select rental_id from rental
    where inventory_id = (
        select inventory_id
        from inventory
        where film_id in(
            select film_id from film 
            where title = 'GONE WITH THE WIND')) 
        and
        customer_id in (select customer_id from customer
        where first_name = 'ANASTASIIA'
        and last_name = 'BATALOVA')),
1.16, current_timestamp) as t1; 

--check that all my three payments are inserted
select * from payment p 
where extract(year from payment_date)='2021'