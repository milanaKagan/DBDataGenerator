--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: sp_delete_airline(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_airline(_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            DELETE FROM airlines
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_delete_airline(_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_airline_flights(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_airline_flights(_id bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    declare
        rows_count int := 0;
    begin
        delete from flights
        using flights
        where flights.aireline_id = _id;

        with rows as  (
            delete from airline
            where airline.id = _id
            RETURNING 1
        )
        select count(*) into rows_count from rows;
        return rows_count;
    end;
    $$;


ALTER FUNCTION public.sp_delete_airline_flights(_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_and_reset_all(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_delete_and_reset_all()
    LANGUAGE plpgsql
    AS $$
    begin
		
		delete from tickets
        where id >= 1;
        alter sequence tickets_id_seq restart with 1;
		
		delete from flights
        where id >= 1;
        alter sequence flights_id_seq restart with 1;
		
		delete from airlines
        where id >= 1;
        alter sequence airlines_id_seq restart with 1;
		
		       
	    delete from customers
        where id >= 1;
        alter sequence customers_id_seq restart with 1;
		
		delete from countries
        where id >= 1;
        alter sequence countries_id_seq restart with 1;
	    
		delete from users
        where id >= 1;
        alter sequence users_id_seq restart with 1;
				
    end;
    $$;


ALTER PROCEDURE public.sp_delete_and_reset_all() OWNER TO postgres;

--
-- Name: sp_delete_country(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_country(_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            DELETE FROM countries
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_delete_country(_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_customer(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_customer(_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            DELETE FROM customers
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_delete_customer(_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_customers_user(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_customers_user(_user_id bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    declare
        rows_count int := 0;
    begin
        delete from customers
        using users
        where customers.user_id = _user_id;

        with rows as  (
            delete from users
            where users.id = _user_id
            RETURNING 1
        )
        select count(*) into rows_count from rows;
        return rows_count;
    end;
    $$;


ALTER FUNCTION public.sp_delete_customers_user(_user_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_flight(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_flight(_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            DELETE FROM flights
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_delete_flight(_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_flight_tickets(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_flight_tickets(_flight_id bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    declare
        rows_count int := 0;
    begin
        delete from tickets
        using flights
        where tickets.flight_id = _flight_id;

        with rows as  (
            delete from flights
            where flights.id = _flight_id
            RETURNING 1
        )
        select count(*) into rows_count from rows;
        return rows_count;
    end;
    $$;


ALTER FUNCTION public.sp_delete_flight_tickets(_flight_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_ticket(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_ticket(_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            DELETE FROM tickets
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_delete_ticket(_id bigint) OWNER TO postgres;

--
-- Name: sp_delete_user(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_delete_user(_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            DELETE FROM users
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_delete_user(_id bigint) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: airlines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.airlines (
    id bigint NOT NULL,
    name text NOT NULL,
    country_id integer NOT NULL,
    user_id bigint NOT NULL
);


ALTER TABLE public.airlines OWNER TO postgres;

--
-- Name: sp_get_airline_by_id(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_airline_by_id(_id bigint) RETURNS SETOF public.airlines
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from airlines
            WHERE id = _id;
        END;
    $$;


ALTER FUNCTION public.sp_get_airline_by_id(_id bigint) OWNER TO postgres;

--
-- Name: sp_get_all_airlines(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_all_airlines() RETURNS TABLE(id bigint, name text, country_id integer, user_id bigint)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from airlines;
        END;
    $$;


ALTER FUNCTION public.sp_get_all_airlines() OWNER TO postgres;

--
-- Name: sp_get_all_coutries(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_all_coutries() RETURNS TABLE(id integer, name text)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from countries;
        END;
    $$;


ALTER FUNCTION public.sp_get_all_coutries() OWNER TO postgres;

--
-- Name: sp_get_all_customers(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_all_customers() RETURNS TABLE(id bigint, first_name text, last_name text, address text, phone_no text, credit_card_no text, user_id bigint)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from customers;
        END;
    $$;


ALTER FUNCTION public.sp_get_all_customers() OWNER TO postgres;

--
-- Name: sp_get_all_flights(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_all_flights() RETURNS TABLE(id bigint, airline_id bigint, origin_country_id integer, destination_country_id integer, departure_time timestamp without time zone, landing_time timestamp without time zone, remaining_tickets integer)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from flights;
        END;
    $$;


ALTER FUNCTION public.sp_get_all_flights() OWNER TO postgres;

--
-- Name: sp_get_all_tickets(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_all_tickets() RETURNS TABLE(id bigint, flight_id bigint, costumer_id bigint)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from tickets;
        END;
    $$;


ALTER FUNCTION public.sp_get_all_tickets() OWNER TO postgres;

--
-- Name: sp_get_all_users(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_all_users() RETURNS TABLE(id bigint, username text, password text, email text)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from users;
        END;
    $$;


ALTER FUNCTION public.sp_get_all_users() OWNER TO postgres;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- Name: sp_get_country_by_id(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_country_by_id(_id bigint) RETURNS SETOF public.countries
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from countries
            WHERE id = _id;
        END;
    $$;


ALTER FUNCTION public.sp_get_country_by_id(_id bigint) OWNER TO postgres;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    id bigint NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    address text NOT NULL,
    phone_no text NOT NULL,
    credit_card_no text NOT NULL,
    user_id bigint NOT NULL
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: sp_get_customer_by_id(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_customer_by_id(_id bigint) RETURNS SETOF public.customers
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from customers
            WHERE id = _id;
        END;
    $$;


ALTER FUNCTION public.sp_get_customer_by_id(_id bigint) OWNER TO postgres;

--
-- Name: flights; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flights (
    id bigint NOT NULL,
    airline_id bigint NOT NULL,
    origin_country_id integer NOT NULL,
    destination_country_id integer NOT NULL,
    departure_time timestamp without time zone NOT NULL,
    landing_time timestamp without time zone NOT NULL,
    remaining_tickets integer NOT NULL
);


ALTER TABLE public.flights OWNER TO postgres;

--
-- Name: sp_get_flight_by_id(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_flight_by_id(_id bigint) RETURNS SETOF public.flights
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from flights
            WHERE id = _id;
        END;
    $$;


ALTER FUNCTION public.sp_get_flight_by_id(_id bigint) OWNER TO postgres;

--
-- Name: tickets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tickets (
    id bigint NOT NULL,
    flight_id bigint NOT NULL,
    costumer_id bigint NOT NULL
);


ALTER TABLE public.tickets OWNER TO postgres;

--
-- Name: sp_get_ticket_by_id(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_ticket_by_id(_id bigint) RETURNS SETOF public.tickets
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from tickets
            WHERE id = _id;
        END;
    $$;


ALTER FUNCTION public.sp_get_ticket_by_id(_id bigint) OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    email text NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: sp_get_user_by_id(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_get_user_by_id(_id bigint) RETURNS SETOF public.users
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT * from users
            WHERE id = _id;
        END;
    $$;


ALTER FUNCTION public.sp_get_user_by_id(_id bigint) OWNER TO postgres;

--
-- Name: sp_insert_airlines(text, integer, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_airlines(_name text, _country_id integer, user_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            new_id bigint;
        BEGIN
            INSERT INTO airlines(name,country_id,user_id)
            VALUES (_name,_country_id,user_id)
            RETURNING id into new_id;

            return new_id;
        END;
    $$;


ALTER FUNCTION public.sp_insert_airlines(_name text, _country_id integer, user_id bigint) OWNER TO postgres;

--
-- Name: sp_insert_countries(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_countries(_name text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            new_id bigint;
        BEGIN
            INSERT INTO countries (name)
            VALUES (_name)
            RETURNING id into new_id;

            return new_id;
        END;
    $$;


ALTER FUNCTION public.sp_insert_countries(_name text) OWNER TO postgres;

--
-- Name: sp_insert_customer(text, text, text, text, text, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_customer(_first_name text, _last_name text, _address text, _phone_no text, _credit_card_no text, _user_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
            new_id bigint;
        BEGIN
            INSERT INTO customers (first_name, last_name, address,
											 phone_no, credit_card_no, user_id)
            VALUES (_first_name, _last_name, _address,
											 _phone_no, _credit_card_no, _user_id)
            RETURNING id into new_id;

            return new_id;
        END;
$$;


ALTER FUNCTION public.sp_insert_customer(_first_name text, _last_name text, _address text, _phone_no text, _credit_card_no text, _user_id bigint) OWNER TO postgres;

--
-- Name: sp_insert_flights(bigint, integer, integer, timestamp without time zone, timestamp without time zone, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_flights(_airline_id bigint, _origin_country_id integer, _destination_country_id integer, _departure_time timestamp without time zone, _landing_time timestamp without time zone, _remaining_tickets integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            new_id bigint;
        BEGIN
            INSERT INTO flights(airline_id , origin_country_id ,destination_country_id,
								departure_time ,landing_time, remaining_tickets)
            VALUES (_airline_id , _origin_country_id ,_destination_country_id,
								_departure_time ,_landing_time, _remaining_tickets)
            RETURNING id into new_id;

            return new_id;
        END;
    $$;


ALTER FUNCTION public.sp_insert_flights(_airline_id bigint, _origin_country_id integer, _destination_country_id integer, _departure_time timestamp without time zone, _landing_time timestamp without time zone, _remaining_tickets integer) OWNER TO postgres;

--
-- Name: sp_insert_tickets(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_tickets(_flight_id bigint, _costumer_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            new_id bigint;
        BEGIN
            INSERT INTO tickets(flight_id,costumer_id)
            VALUES (_flight_id,_costumer_id)
            RETURNING id into new_id;

            return new_id;
        END;
    $$;


ALTER FUNCTION public.sp_insert_tickets(_flight_id bigint, _costumer_id bigint) OWNER TO postgres;

--
-- Name: sp_insert_user(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_insert_user(_username text, _password text, _email text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            new_id bigint;
        BEGIN
            INSERT INTO users (username, password, email)
            VALUES (_username, _password, _email)
            RETURNING id into new_id;

            return new_id;
        END;
    $$;


ALTER FUNCTION public.sp_insert_user(_username text, _password text, _email text) OWNER TO postgres;

--
-- Name: sp_update_airline(bigint, text, integer, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_update_airline(_id bigint, _name text, _country_id integer, _user_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            UPDATE airlines
            SET name = _name,country_id= _country_id, user_id=_user_id
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_update_airline(_id bigint, _name text, _country_id integer, _user_id bigint) OWNER TO postgres;

--
-- Name: sp_update_country(integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_update_country(_id integer, _name text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            UPDATE countries
            SET name = _name
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_update_country(_id integer, _name text) OWNER TO postgres;

--
-- Name: sp_update_customer(bigint, text, text, text, text, text, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_update_customer(_id bigint, _first_name text, _last_name text, _address text, _phone_no text, _credit_card_no text, _user_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            UPDATE customers
            SET first_name=_first_name, last_name=_last_name,
			   address= _address, phone_no=_phone_no, credit_card_no =_credit_card_no, user_id = _user_id
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_update_customer(_id bigint, _first_name text, _last_name text, _address text, _phone_no text, _credit_card_no text, _user_id bigint) OWNER TO postgres;

--
-- Name: sp_update_flights(bigint, bigint, integer, integer, timestamp without time zone, timestamp without time zone, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_update_flights(_id bigint, _airline_id bigint, _origin_country_id integer, _destination_country_id integer, _departure_time timestamp without time zone, _landing_time timestamp without time zone, _remaining_tickets integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            UPDATE flights
            SET airline_id=_airline_id, origin_country_id=_origin_country_id,
			   destination_country_id= destination_country_id, departure_time=_departure_time, 
				landing_time =_landing_time, remaining_tickets = _remaining_tickets
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_update_flights(_id bigint, _airline_id bigint, _origin_country_id integer, _destination_country_id integer, _departure_time timestamp without time zone, _landing_time timestamp without time zone, _remaining_tickets integer) OWNER TO postgres;

--
-- Name: sp_update_ticket(bigint, bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_update_ticket(_id bigint, _flight_id bigint, _costumer_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            UPDATE tickets
            SET flight_id= _flight_id, costumer_id=_costumer_id
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_update_ticket(_id bigint, _flight_id bigint, _costumer_id bigint) OWNER TO postgres;

--
-- Name: sp_update_user(bigint, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_update_user(_id bigint, _username text, _password text, _email text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        DECLARE
            rows_count int := 0;
        BEGIN
            WITH rows AS (
            UPDATE users
            SET username = _username, password = _password, 
                        email = _email
            WHERE id = _id
            RETURNING 1)
            select count(*) into rows_count from rows;
            return rows_count;
        END;
    $$;


ALTER FUNCTION public.sp_update_user(_id bigint, _username text, _password text, _email text) OWNER TO postgres;

--
-- Name: sp_upsert_customer(text, text, text, text, text, bigint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_upsert_customer(_first_name text, _last_name text, _address text, _phone_no text, _credit_card_no text, _user_id bigint)
    LANGUAGE plpgsql
    AS $$
    begin
        if not exists(select 1 from customers where phone_no = _phone_no or credit_card_no=_credit_card_no
					 or user_id=_user_id) then
        insert into customers (first_name, last_name,
		address, phone_no, credit_card_no, user_id)
        values(_first_name, _last_name,
		_address, _phone_no, _credit_card_no, _user_id);
        else
            update customers
            SET first_name=_first_name,last_name= _last_name,
			address=_address,phone_no= _phone_no, credit_card_no=_credit_card_no, 
			user_id=_user_id
            where phone_no = _phone_no or credit_card_no=_credit_card_no
					 or user_id=_user_id;
        end if;
    end;
    $$;


ALTER PROCEDURE public.sp_upsert_customer(_first_name text, _last_name text, _address text, _phone_no text, _credit_card_no text, _user_id bigint) OWNER TO postgres;

--
-- Name: sp_upsert_user(text, text, text); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_upsert_user(_username text, _password text, _email text)
    LANGUAGE plpgsql
    AS $$
    begin
        INSERT INTO users (username, password, email)
        VALUES(_username, _password, _email)
        ON CONFLICT (username)
        DO
           UPDATE SET username = _username, password=_password, email=_email;
    end;
    $$;


ALTER PROCEDURE public.sp_upsert_user(_username text, _password text, _email text) OWNER TO postgres;

--
-- Name: airlines_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.airlines ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.airlines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.countries ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.customers ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: flights_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.flights ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.flights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tickets ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.users ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: airlines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.airlines (id, name, country_id, user_id) FROM stdin;
2	fake	1	1
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.countries (id, name) FROM stdin;
1	Israel
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (id, first_name, last_name, address, phone_no, credit_card_no, user_id) FROM stdin;
1	fake	fake	fake1	fake1	fake1	1
\.


--
-- Data for Name: flights; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flights (id, airline_id, origin_country_id, destination_country_id, departure_time, landing_time, remaining_tickets) FROM stdin;
\.


--
-- Data for Name: tickets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tickets (id, flight_id, costumer_id) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password, email) FROM stdin;
1	mili	milipass	milimail
\.


--
-- Name: airlines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.airlines_id_seq', 4, true);


--
-- Name: countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.countries_id_seq', 1, true);


--
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_id_seq', 2, true);


--
-- Name: flights_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.flights_id_seq', 1, false);


--
-- Name: tickets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tickets_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: airlines airlines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airlines
    ADD CONSTRAINT airlines_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: flights flights_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_pkey PRIMARY KEY (id);


--
-- Name: tickets tickets_flight_id_costumer_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_flight_id_costumer_id_key UNIQUE (flight_id, costumer_id);


--
-- Name: tickets tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_pkey PRIMARY KEY (id);


--
-- Name: customers unique_credit_card_no; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT unique_credit_card_no UNIQUE (credit_card_no);


--
-- Name: users unique_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT unique_email UNIQUE (email);


--
-- Name: countries unique_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT unique_name UNIQUE (name);


--
-- Name: airlines unique_name_airline; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airlines
    ADD CONSTRAINT unique_name_airline UNIQUE (name);


--
-- Name: customers unique_phone_no; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT unique_phone_no UNIQUE (phone_no);


--
-- Name: customers unique_user_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT unique_user_id UNIQUE (user_id);


--
-- Name: airlines unique_user_id_airline; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airlines
    ADD CONSTRAINT unique_user_id_airline UNIQUE (user_id);


--
-- Name: users unique_username; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT unique_username UNIQUE (username);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: flights fk_airline_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT fk_airline_id FOREIGN KEY (airline_id) REFERENCES public.airlines(id);


--
-- Name: airlines fk_country_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airlines
    ADD CONSTRAINT fk_country_id FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: tickets fk_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT fk_customer_id FOREIGN KEY (costumer_id) REFERENCES public.customers(id);


--
-- Name: flights fk_destination_country_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT fk_destination_country_id FOREIGN KEY (destination_country_id) REFERENCES public.countries(id);


--
-- Name: tickets fk_flight_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT fk_flight_id FOREIGN KEY (flight_id) REFERENCES public.flights(id);


--
-- Name: flights fk_origin_country_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT fk_origin_country_id FOREIGN KEY (origin_country_id) REFERENCES public.countries(id);


--
-- Name: customers fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: airlines fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airlines
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

