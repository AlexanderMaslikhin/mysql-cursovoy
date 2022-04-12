DROP DATABASE IF EXISTS gb_mysql_curs;

CREATE DATABASE gb_mysql_curs;
USE gb_mysql_curs;

CREATE TABLE document_types (
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50)
);

CREATE TABLE abonents (
	id SERIAL PRIMARY KEY,
	firstname VARCHAR(100) NOT NULL,
	midname VARCHAR(100) DEFAULT NULL,
	lastname VARCHAR(100) NOT NULL,
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
	house_litera VARCHAR(10) DEFAULT NULL
);

-- Подключенные квартиры в домах
CREATE TABLE connected_addresses (
	id SERIAL PRIMARY KEY,
	house_id BIGINT UNSIGNED NOT NULL,
	flat_no VARCHAR(10),
	UNIQUE KEY (house_id, flat_no), 
	FOREIGN KEY (house_id) REFERENCES houses(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE tariffs (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30)
);

-- Договора
CREATE TABLE accounts (
	id SERIAL PRIMARY KEY, -- Номер лицевого счета
	contract VARCHAR(30) UNIQUE NOT NULL, -- номер договора
	abonent_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE NOW(),
	contract_address_id BIGINT UNSIGNED, -- адрес подключения по договору
	money_balance DECIMAL,
	current_tariff_id BIGINT UNSIGNED,
	is_active BIT DEFAULT 1,
	FOREIGN KEY (abonent_id) REFERENCES abonents(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (contract_address_id) REFERENCES connected_addresses(id) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (current_tariff_id) REFERENCES tariffs(id) ON DELETE RESTRICT ON UPDATE CASCADE
);


-- periods
CREATE TABLE periods (
	id SERIAL PRIMARY KEY,
	len INT UNSIGNED NOT NULL -- продолжительность рассчетного периода в секундах
);

-- список услуг
CREATE TABLE services (
	id SERIAL PRIMARY KEY,
	s_name VARCHAR(100), -- наименование услуги
	price DECIMAL, 
	period_id BIGINT UNSIGNED,
	FOREIGN KEY (period_id) REFERENCES periods(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Услуги, подключенные к тарифам
CREATE TABLE tariffs_services (
	tariff_id BIGINT UNSIGNED NOT NULL,
	service_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY(tariff_id, service_id),
	FOREIGN KEY (tariff_id) REFERENCES tariffs(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Услуги, подключенные вне тарифа
CREATE TABLE accounts_services (
	account_id BIGINT UNSIGNED NOT NULL,
	service_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY(account_id, service_id),
	FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE RESTRICT ON UPDATE CASCADE 
);

CREATE TABLE payment_agents (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100)
);

CREATE TABLE account_payments (
	id SERIAL PRIMARY KEY,
	account_id BIGINT UNSIGNED NOT NULL,
	value DECIMAL NOT NULL DEFAULT 0,
	agent_id BIGINT UNSIGNED,
	pay_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (agent_id) REFERENCES payment_agents(id) ON DELETE RESTRICT ON UPDATE CASCADE 	
);

CREATE TABLE registered_macs (
	mac_address CHAR(17) PRIMARY KEY -- aa:bb:cc:dd:ee:ff
);

-- справочник IP адреса 
CREATE TABLE ip_adresses (
	ip_address INT UNSIGNED PRIMARY KEY,
	account_id BIGINT UNSIGNED DEFAULT NULL,
	mac_address CHAR(17) UNIQUE DEFAULT NULL, 
	FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (mac_address) REFERENCES registered_macs(mac_address) ON DELETE SET NULL ON UPDATE CASCADE
);



-- 