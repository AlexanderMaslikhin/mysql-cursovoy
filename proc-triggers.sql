EXPLAIN SELECT a.id,
	a2.lastname,
	a2.firstname,
	a2.midname,
	a.login,
	CONCAT(h.street, ', д.', h.house_num, ', кв.', ca.flat_no) as address,
	t.name AS tarif,
	t.price AS price,
	a.money_balance,
	INET_NTOA(ia.ip_address) AS ip,
	rm.mac_address
FROM accounts a 
JOIN abonents a2 ON a.abonent_id = a2.id 
JOIN connected_addresses ca ON a.contract_address_id = ca.id 
JOIN houses h ON ca.house_id = h.id
JOIN tariffs t ON a.current_tariff_id = t.id
JOIN registered_macs rm ON rm.account_id = a.id 
JOIN ip_adresses ia ON ia.binded_mac = rm.mac_address;

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