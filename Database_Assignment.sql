	/* solution query for question 1 */

SELECT COUNT(u_id) AS total_num_of_users FROM public.users;



	
	/* solution query for question 2 */

SELECT COUNT(transfer_id) AS total_transfers_in_CFA_currency 

FROM public.transfers 

WHERE send_amount_currency = 'CFA';



	
	/* solution query for question 3 */

SELECT COUNT(DISTINCT u_id) AS user_transfer_in_CFA_currency 

FROM public.transfers 

WHERE send_amount_currency = 'CFA';




	/* solution query for question 4 */

SELECT EXTRACT(MONTH FROM when_created) AS atx_id_transaction_by_month 

FROM public.agent_transactions 

WHERE when_created >= '2018-01-10 00:00:00'

GROUP BY atx_id_transaction_by_month;




	/* solution query for question 5 */

SELECT 
	SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS withdrawal,  
	SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS deposit, 

CASE WHEN 
	((SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END)) > ((SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END))) * -1) 
	
	THEN 'withdrawer' 

ELSE 'depositer' END AS agent_status, COUNT(*)

FROM agent_transactions 

WHERE 
	when_created  BETWEEN (now()  - '1 WEEK'::INTERVAL) AND now();




	/* solution query for question 6 */

SELECT agents.city,  COUNT(amount)  

FROM agent_transactions 

INNER JOIN agents ON agents.agent_id = agent_transactions.agent_id 

WHERE agent_transactions.when_created  > CURRENT_DATE -interval '7 days'  

GROUP BY agents.city;




	/* solution query for question 7 */

SELECT agents.country, agents.city, 
	SUM(agent_transactions.amount) AS transaction_volume

FROM agents, agent_transactions

WHERE (agent_transactions.when_created >= date_trunc('week', current_timestamp - interval '1 week'))

AND agent_transactions.when_created < date_trunc('week', current_timestamp)

GROUP BY country, city;




	/* solution query for question 8 */

SELECT 
    SUM(send_amount_scalar) AS Volume,
    transfers.kind,
    wallets.ledger_location AS Location

FROM transfers 

INNER JOIN wallets ON wallets.wallet_id = transfers.dest_wallet_id

WHERE 
    wallets.when_created  BETWEEN (now()  - '1 WEEK'::INTERVAL) AND now()
    
GROUP BY  wallets.ledger_location, transfers.kind;




	/* solution query for question 9 */

SELECT 
	COUNT(transfers.source_wallet_id) AS Number_of_unique_senders,
	COUNT(transfers.transfer_id) AS Transaction_Count,
	transfers.kind,
	wallets.ledger_location AS Country,
	SUM(transfers.send_amount_scalar) AS Volume

FROM  transfers

JOIN wallets ON transfers.source_wallet_id = wallets.wallet_id

WHERE transfers.when_created > (NOW() -interval '1 week')
	
GROUP BY wallets.ledger_location, transfers.kind;




	/* solution query for question 10 */

SELECT 
	transfers.send_amount_scalar, transfers.source_wallet_id,
	wallets.wallet_id

FROM  transfers

INNER JOIN wallets ON transfers.transfer_id = wallets.wallet_id

WHERE transfers.send_amount_scalar > 10 AND
	(transfers.send_amount_currency = 'CFA' AND 
	 transfers.when_created > CURRENT_DATE -interval '1 month');