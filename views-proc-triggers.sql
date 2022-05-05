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


/* Триггер при добавлении  аккаунта добавляющий записи в таблицу даты списаний */

DELIMITER //
CREATE TRIGGER insert_account AFTER INSERT ON accounts
FOR EACH ROW
BEGIN
	DECLARE new_date DATE;
    SET new_date = add_tariff_period(NEW.current_tariff_id);
    INSERT INTO tariffs_write_offs VALUES (NEW.id, new_date);
END//

-- функция возвращает дату следущего списания по тарифу
DELIMITER //
CREATE FUNCTION add_tariff_period(tariff_id INT)
RETURNS DATE DETERMINISTIC
BEGIN
	DECLARE period, cnt VARCHAR(20);
    DECLARE new_date DATE;
	SELECT p.duration, p.durations_count INTO period, cnt 
    FROM tariffs t 
    JOIN periods p ON t.period_id = p.id
    WHERE t.id = tariff_id;
    CASE period 
		WHEN 'DAY' THEN SET new_date = DATE_ADD(CURDATE(), INTERVAL cnt DAY);
		WHEN 'MONTH' THEN SET new_date = DATE_ADD(CURDATE(), INTERVAL cnt MONTH);
		WHEN 'WEEK' THEN SET new_date = DATE_ADD(CURDATE(), INTERVAL cnt WEEK);
		WHEN 'YEAR' THEN SET new_date = DATE_ADD(CURDATE(), INTERVAL cnt YEAR);
	END CASE;
    RETURN new_date;
END//

/* функция возвращает дату следущего списания по услуге */
DELIMITER //
CREATE FUNCTION add_service_period(service_id INT)
RETURNS DATE DETERMINISTIC
BEGIN
	DECLARE period, cnt VARCHAR(20);
    DECLARE new_date DATE;
	SELECT p.duration, p.durations_count INTO period, cnt 
    FROM services s 
    JOIN periods p ON s.period_id = p.id
    WHERE s.id = service_id;
    CASE period 
		WHEN 'DAY' THEN SET new_date = DATE_ADD(CURDATE(), INTERVAL cnt DAY);
		WHEN 'MONTH' THEN SET new_date = DATE_ADD(CURDATE(), INTERVAL cnt MONTH);
		WHEN 'WEEK' THEN SET new_date = DATE_ADD(CURDATE(), INTERVAL cnt WEEK);
		WHEN 'YEAR' THEN SET new_date = DATE_ADD(CURDATE(), INTERVAL cnt YEAR);
	END CASE;
    RETURN new_date;
END//

/* Представление по заблокированным аккаунтам пользователей */
DELIMITER ;
CREATE OR REPLACE VIEW blocked_accounts AS 
SELECT
	CONCAT(ab.firstname, " ", ab.lastname) as fio,
	CONCAT(h.street, ", д.", h.house_num, ", кв.", ca.flat_no),
	a.contract,
    a.login,
    a.money_balance
FROM accounts a
JOIN abonents ab ON a.abonent_id = ab.id
JOIN connected_addresses ca ON a.contract_address_id = ca.id
JOIN houses h ON ca.house_id = h.id
WHERE a.money_balance <= 0;

/* Представление по сегодняшним списаниям */
DELIMITER ;
CREATE OR REPLACE VIEW today_write_offs AS
	SELECT two.account_id, 
				a.current_tariff_id,
				a.next_tariff_id,
				t.price
	FROM tariffs_write_offs two 
	JOIN accounts a ON two.account_id = a.id 
	JOIN tariffs t ON a.current_tariff_id = t.id
	WHERE two.next_write_off_at = CURDATE()
    UNION ALL
    SELECT asw.account_id,
                   asw.service_id,
                   -1, -- для совпадения количества полей
                   services.price 
	FROM accounts_services_write_offs asw
    JOIN services ON asw.service_id = services.id
    WHERE asw.next_write_off_at = CURDATE();

/* Процедуру, выполняющая списания  */
DELIMITER //
CREATE PROCEDURE write_off()
BEGIN
	DECLARE a_id, current_tariff, next_tariff INT;
    DECLARE price DECIMAL;
    DECLARE is_end INT DEFAULT 0;

	DECLARE cur CURSOR FOR SELECT * FROM today_write_offs;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_end = 1;

    OPEN cur;
    cycle: LOOP
		FETCH cur INTO a_id, current_tariff, next_tariff, price;
        IF is_end THEN LEAVE cycle;
        END IF;
        UPDATE accounts SET money_balance = money_balance - price WHERE id = a_id;
        IF current_tariff != next_tariff AND next_tariff != -1 THEN
			UPDATE accounts SET current_tariff_id = next_tariff WHERE id = a_id;
            SET current_tariff = nex_tariff;
		END IF;
        IF next_tariff != -1 THEN
			UPDATE tariffs_write_offs SET next_write_off_at = add_tariff_period(current_tarif) WHERE account_id = a_id;
		ELSE
			UPDATE accounts_services_write_offs SET next_write_off_at = add_service_period(current_tariff) WHERE account_id = a_id;			
        END IF;
	END LOOP;
    CLOSE cur;
END//
DELIMITER ;

