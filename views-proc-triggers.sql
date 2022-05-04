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


/* Создать процедуру, прогоняющая по этой таблице и списывающая деньги, если дата совпадает */
/* Создать триггер при добавлении и смене списка услуг аккаунта добавляющий записи в эту таблицу */
DELIMITER //
CREATE TRIGGER change_account AFTER UPDATE ON accounts
FOR EACH ROW
BEGIN
	IF NEW.current_tariff_id != OLD.current_tariff_id THEN
		
	END IF;
END//
/* Представление по сегодняшним списаниям ;/