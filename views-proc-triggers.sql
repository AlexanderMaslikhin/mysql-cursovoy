/* процедура заполнения таблицы ip адресов. начальная */
DELIMITER //
CREATE PROCEDURE fill_ip_adresses(start_address VARCHAR(30), ip_cnt INT)
BEGIN
	DECLARE start_ip INT UNSIGNED;
	DECLARE counter INT DEFAULT 0;
	SET start_ip = INET_ATON(start_address);
	WHILE counter < ip_cnt DO
		INSERT INTO ip_adresses (ip_address) VALUES (start_ip);
		SET counter = counter + 1;
		SET start_ip = start_ip + 1;
	END WHILE;
END//

-- CALL fill_ip_adresses('192.168.0.0', 25);


/* Добавляет деньги на лицевой счет при оплате */
DELIMITER //
CREATE TRIGGER add_money_trigger AFTER INSERT ON account_payments
FOR EACH ROW
	UPDATE accounts SET money_balance = money_balance + NEW.value WHERE accounts.id = NEW.account_id;
END//

CREATE TABLE next_write_offs (
	id SERIAL PRIMARY KEY,
    account_id BIGINT UNSIGNED NOT NULL,
    service_id BIGINT UNSIGNED NOT NULL,
    write_off_date DATE NOT NULL,
    INDEX (account_id),
    INDEX (service_id),
    INDEX (write_off_date),
    FOREIGN KEY (account_id) REFERENCES accounts(id),
    FOREIGN KEY (service_id) REFERENCES services(id)
);
/* Создать процедуру, прогоняющая по этой таблице и списывающая деньги, если дата совпадает */
/* Создать триггер при добавлении и смене списка услуг аккаунта добавляющий записи в эту таблицу */