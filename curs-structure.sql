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
	gender ENUM('f', 'm'),
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
	INDEX(street, house_num)
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
	name VARCHAR(30),
	price DECIMAL
);

-- Договора
CREATE TABLE accounts (
	id SERIAL PRIMARY KEY, -- Номер лицевого счета
	contract VARCHAR(30) UNIQUE NOT NULL, -- номер договора
	abonent_id BIGINT UNSIGNED NOT NULL,
	login VARCHAR(50) UNIQUE NOT NULL,
	pass_hash VARCHAR(255) NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE NOW(),
	contract_address_id BIGINT UNSIGNED, -- адрес подключения по договору
	money_balance DECIMAL,
	current_tariff_id BIGINT UNSIGNED,
	is_active BOOL DEFAULT 1,
	FOREIGN KEY (abonent_id) REFERENCES abonents(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (contract_address_id) REFERENCES connected_addresses(id) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (current_tariff_id) REFERENCES tariffs(id) ON DELETE RESTRICT ON UPDATE CASCADE
);


-- periods
CREATE TABLE periods (
	id SERIAL PRIMARY KEY,
    duration VARCHAR(20),
	durations_count TINYINT UNSIGNED NOT NULL -- продолжительность рассчетного периода (1 DAY, 1 MONTH, 1 WEEK and so on)
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

-- Все услуги, подключенные к абоненту ВНЕ ТАРИФА с датами создания и следующего списания
CREATE TABLE accounts_services_write_offs (
	account_id BIGINT UNSIGNED NOT NULL,
	service_id BIGINT UNSIGNED NOT NULL,
    activated_at DATE NOT NULL,
    next_write_off_at DATE NOT NULL,
    INDEX (next_write_off_at),
	PRIMARY KEY(account_id, service_id),
	FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE RESTRICT ON UPDATE CASCADE 
);

-- Списки тарифов абонентов с датами создания и следующего списания
CREATE TABLE tariffs_write_offs (
	account_id BIGINT UNSIGNED NOT NULL,
    next_write_off_at DATE NOT NULL,
    PRIMARY KEY(account_id),
    INDEX (next_write_off_at),
	FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE ON UPDATE CASCADE
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
	INDEX(account_id),
	INDEX(agent_id),
	FOREIGN KEY (account_id) REFERENCES accounts(id),
	FOREIGN KEY (agent_id) REFERENCES payment_agents(id) ON DELETE RESTRICT ON UPDATE CASCADE 	
);

CREATE TABLE registered_macs (
	mac_address CHAR(17) PRIMARY KEY, -- aa:bb:cc:dd:ee:ff
	account_id BIGINT UNSIGNED DEFAULT NULL,
    INDEX(account_id),
	FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- справочник IP адреса 
CREATE TABLE ip_adresses (
	ip_address INT UNSIGNED PRIMARY KEY,
	binded_mac CHAR(17) DEFAULT NULL,
    INDEX(binded_mac),
	FOREIGN KEY (binded_mac) REFERENCES registered_macs(mac_address) ON DELETE SET NULL ON UPDATE CASCADE
);



-- 