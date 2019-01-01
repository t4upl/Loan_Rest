CREATE OR REPLACE FUNCTION createDB() RETURNS void AS $$
    DECLARE
    BEGIN
        RAISE NOTICE 'createDB -start';

        -- CREATE TABLES

        -- table contains customers/users of application
        CREATE TABLE customer (
          id serial,
          name text,
          PRIMARY KEY (id)
        );

        -- loan(s) attached to customer
        CREATE TABLE product (
          id serial,
          customer_id integer NOT NULL,
          product_type_id integer NOT NULL,
          PRIMARY KEY (id)
        );

        --types of loan that customer can buy
        CREATE TABLE product_type (
          id serial,
          name text NOT NULL,
          PRIMARY KEY (id)
        );

        --setting of loans that customer can buy
        CREATE TABLE product_type_setting (
          id serial,
          product_type_id integer NOT NULL,
          setting_id integer NOT NULL,
          value text,
          PRIMARY KEY (id),
          UNIQUE (product_type_id, setting_id)
        );

         --variables that can describe a loan
        CREATE TABLE IF NOT EXISTS setting (
          id serial,
          name text NOT NULL,
          data_type_id integer,
          is_runtime_input boolean,
          PRIMARY KEY (id),
          UNIQUE(name)
        );

	-- dictionary describing data types
        CREATE TABLE IF NOT EXISTS data_type (
          id serial,
          name text NOT NULL,
          PRIMARY KEY (id),
          UNIQUE(name)
        );

         -- details of product owned by customer
        CREATE TABLE IF NOT EXISTS product_setting (
          id serial,
          product_id integer NOT NULL,
          setting_id integer NOT NULL,
          value text,
          PRIMARY KEY (id),
          UNIQUE (product_id, setting_id)
        );

        -- CREATE FOREIGN KEYS

        --product
        ALTER TABLE product ADD CONSTRAINT fk_product_customer_id FOREIGN KEY(customer_id) REFERENCES customer(id);
        ALTER TABLE product ADD CONSTRAINT fk_product_product_type_id FOREIGN KEY (product_type_id) REFERENCES product_type(id);

        --product type setting
        ALTER TABLE product_type_setting ADD CONSTRAINT fk_product_type_setting_product_type_id FOREIGN KEY (product_type_id) REFERENCES product_type(id);
        ALTER TABLE product_type_setting ADD CONSTRAINT fk_product_type_setting_setting_id FOREIGN KEY (setting_id) REFERENCES setting(id);

        --prorduct_setting
        ALTER TABLE product_setting ADD CONSTRAINT fk_product_setting_product_id FOREIGN KEY (product_id) REFERENCES product(id);
        ALTER TABLE product_setting ADD CONSTRAINT fk_product_setting_setting_id FOREIGN KEY (setting_id) REFERENCES setting(id);

        --setting
        ALTER TABLE setting ADD CONSTRAINT fk_setting_datat_type_id FOREIGN KEY (data_type_id) REFERENCES data_type(id);

        RAISE NOTICE 'createDB -end';
    END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insertTestData() RETURNS void AS $$
    DECLARE
    BEGIN
        RAISE NOTICE 'insertTestData - start';

        -- insert a customer
        INSERT INTO customer (id, name) VALUES (1, 'Johny');

        --insert a product
        INSERT INTO product_type (id, name) VALUES (1, 'test product type');

        --insert data_type
        INSERT INTO data_type (id, name) VALUES (1, 'Integer');
        INSERT INTO data_type (id, name) VALUES (2, 'LocalDateTime');
        INSERT INTO data_type (id, name) VALUES (3, 'LocalTime');
        INSERT INTO data_type (id, name) VALUES (4, 'String');
        INSERT INTO data_type (id, name) VALUES (5, 'Double');

        --insert settings describing a product
        INSERT INTO setting (id, name, data_type_id, is_runtime_input) VALUES (1, 'min amount', 1, '0');
        INSERT INTO setting (id, name, data_type_id, is_runtime_input) VALUES (2, 'max amount', 1, '0');
        INSERT INTO setting (id, name, data_type_id, is_runtime_input) VALUES (3, 'min term', 1, '0');
        INSERT INTO setting (id, name, data_type_id, is_runtime_input) VALUES (4, 'max term', 1, '0');
        INSERT INTO setting (id, name, data_type_id, is_runtime_input) VALUES (5, 'min rejection time', 3, '0');
        INSERT INTO setting (id, name, data_type_id, is_runtime_input) VALUES (6, 'max rejection time', 3, '0');
        INSERT INTO setting (id, name, data_type_id, is_runtime_input) VALUES (7, 'loan type', 4, '0');
        INSERT INTO setting (id, name, data_type_id, is_runtime_input) VALUES (8, 'rate of interest', 1, '0');
        INSERT INTO setting (id, name, data_type_id, is_runtime_input) VALUES (9, 'due date', 2, '1');
        INSERT INTO setting (id, name, data_type_id, is_runtime_input) VALUES (10, 'extension term', 1, '0');
        INSERT INTO setting (id, name, data_type_id, is_runtime_input) VALUES (11, 'amount', 1, '1');
        INSERT INTO setting (id, name, data_type_id, is_runtime_input) VALUES (12, 'application date', 2, '1');
        INSERT INTO setting (id, name, data_type_id, is_runtime_input) VALUES (13, 'amount to pay', 1, '1');
        INSERT INTO setting (id, name, data_type_id, is_runtime_input) VALUES (14, 'term', 1, '1');

        --insert settings describing a debt with product_type_id = 1
        INSERT INTO product_type_setting (id, product_type_id, setting_id, value) VALUES (1, 1, 1, '1000');
        INSERT INTO product_type_setting (id, product_type_id, setting_id, value) VALUES (2, 1, 2, '5000');
        INSERT INTO product_type_setting (id, product_type_id, setting_id, value) VALUES (3, 1, 3, '3');
        INSERT INTO product_type_setting (id, product_type_id, setting_id, value) VALUES (4, 1, 4, '60');
        INSERT INTO product_type_setting (id, product_type_id, setting_id, value) VALUES (5, 1, 5, '00:00:00');
        INSERT INTO product_type_setting (id, product_type_id, setting_id, value) VALUES (6, 1, 6, '06:00:00');
        INSERT INTO product_type_setting (id, product_type_id, setting_id, value) VALUES (7, 1, 7, 'principal');
        INSERT INTO product_type_setting (id, product_type_id, setting_id, value) VALUES (8, 1, 8, '10');
        INSERT INTO product_type_setting (id, product_type_id, setting_id, value) VALUES (9, 1, 9, '');
        INSERT INTO product_type_setting (id, product_type_id, setting_id, value) VALUES (10, 1, 10, '7');
        INSERT INTO product_type_setting (id, product_type_id, setting_id, value) VALUES (11, 1, 11, '');
        INSERT INTO product_type_setting (id, product_type_id, setting_id, value) VALUES (12, 1, 12, '');
        INSERT INTO product_type_setting (id, product_type_id, setting_id, value) VALUES (13, 1, 13, '');
        INSERT INTO product_type_setting (id, product_type_id, setting_id, value) VALUES (14, 1, 14, '');


        --insert product
        INSERT INTO product (id, product_type_id, customer_id) VALUES (1, 1, 1);

        --insert product setting
        INSERT INTO product_setting (id, product_id, setting_id, value)
        SELECT nextval('product_setting_id_seq'), 1, setting_id, value
        FROM product_type_setting
        WHERE product_type_id = 1;

        update product_setting
        set value = '2018-11-02 15:12:54'
        where setting_id = (select id from setting where name = 'application date');

        update product_setting
        set value = '5'
        where setting_id = (select id from setting where name = 'term');

        update product_setting
        set value = '2018-11-07 15:12:54'
        where setting_id = (select id from setting where name = 'due date');


        update product_setting
        set value = '5500'
        where setting_id = (select id from setting where name = 'amount to pay');


        update product_setting
        set value = '5000'
        where setting_id = (select id from setting where name = 'amount');

        RAISE NOTICE 'insertTestData - end';
    END;
$$ LANGUAGE plpgsql;

 SELECT current_database();

BEGIN;
  SELECT createDB();
  SELECT insertTestData();
COMMIT;