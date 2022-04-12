CREATE DATABASE IF NOT EXISTS gb_mysql_curs;
USE gb_mysql_curs;

CREATE TABLE document_types (
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50)
);

CREATE TABLE abonents (
	id SERIAL PRIMARY KEY,
	firstname VARCHAR(100) NOT NULL,
	midname VARCHAR(100) DEFAULT NULL,
	lastname VARCHAR(100) NOt NULL,
	document_type_id TINYINT UNSIGNED NOT NULL,
	document_number VARCHAR(30) UNIQUE,
	document_address VARCHAR(200),
	phone CHAR(11) UNIQUE NOT NULL,
	birthday DATE NOT NULL,
	FOREIGN KEY (document_type_id) REFERENCES document_types(id)
);


-- Подключенные дома
CREATE TABLE houses (
	id SERIAL PRIMARY KEY,
	street VARCHAR(200) NOT NULL,
	house_num INT UNSIGNED DEFAULT NULL,
	house_korpus VARCHAR(10) DEFAULT NULL,
	house_litera VARCHAR(10) DEFAULT NULL,
);

-- Подключенные квартиры в домах
CREATE TABLE connected_adresses (
	id SERIAL PRIMARY KEY,
	house_id BIGINT UNSIGNED NOT NULL,
	flat_no VARCHAR(10),
	UNIQUE KEY (house_id, flat_no), 
	FOREIGN KEY (house_id) REFERENCES houses(id)
)

-- Договора
CREATE TABLE accounts (
	id SERIAL PRIMARY KEY, -- Номер лицевого счета
	contract VARCHAR(30) UNIQUE NOT NULL, -- номер договора
	abonent_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	contract_address_id INT UNSIGNED NOT NULL, -- адрес подключения по договору
	money_balance DECIMAL,
	current_tariff_id BIGINT UNSIGNED,
	next_tariff_id BIGINT UNSIGNED,
	is_active BIT DEFAULT 1,
	FOREIGN KEY (abonent_id) REFERENCES abonents(id),
	FOREIGN KEY (contract_address_id) REFERENCES connected_addresses(id),
	FOREIGN KEY (current_tariff_id) REFERENCES tariffs(id),
	FOREIGN KEY (next_tariff_id) REFERENCES tariffs(id)
);

CREATE TABLE tariffs (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30)
);

-- periods
CREATE TABLE periods (
	id SERIAL PRIMARY KEY,
	len INT UNSIGNED NOT NULL -- продолжительность рассчетного мериода в секундах
)

-- список услуг
CREATE TABLE services (
	id SERIAL PRIMARY KEY,
	s_name VARCHAR(100), -- наименование услуги
	price DECIMAL, 
	period_id BIGINT UNSIGNED,
	FOREIGN KEY (period_id) REFERENCES periods(id)
);

-- Услуги по тарифам
CREATE TABLE tariffs_services (
	tariff_id BIGINT UNSIGNED NOT NULL,
	service_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY(tariff_id, service_id),
	FOREIGN KEY (tariff_id) REFERENCES tariffs(id),
	FOREIGN KEY (service_id) REFERENCES services(id)
);

-- Списки подключенных услуг к аккаунтам
CREATE TABLE accounts_services (
	account_id BIGINT UNSIGNED NOT NULL,
	service_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY(account_id, service_id),
	FOREIGN KEY (account_id) REFERENCES accounts(id),
	FOREIGN KEY (service_id) REFERENCES services(id)
);


