/* Выборка списка лицевых счетов и договоров абонента с балансом и адресами */
SELECT CONCAT(a2.firstname, " ", a2.midname, " ", a2.lastname) AS fio,
	   CONCAT(h.street, ", д.", h.house_num, ", кв.", ca.flat_no),
       a1.login,
	   a1.contract,
       a1.money_balance
FROM accounts a1
JOIN abonents a2 ON a1.abonent_id = a2.id
JOIN connected_addresses ca ON a1.contract_address_id = ca.id
JOIN houses h ON ca.house_id = h.id
WHERE a1.abonent_id = 3;

/* Выборка поступивших платежей за период с аггрегацией по агентам платежа*/
SELECT pa.name,
       SUM(ap.value) AS total_agent
FROM account_payments ap
JOIN payment_agents pa ON ap.agent_id = pa.id
GROUP BY ap.agent_id
ORDER BY total_agent
DESC;

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

CALL fill_ip_adresses('192.168.0.0', 25);
ALTER TABLE ip_adresses  DROP COLUMN account_id;
ALTER TABLE registered_macs ADD INDEX(account_id);