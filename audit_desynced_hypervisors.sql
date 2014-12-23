SELECT ci.id,ci.name,changeop.optype,chang.date
FROM hypervisor
INNER JOIN functionalci ci ON hypervisor.id = ci.id
INNER JOIN priv_changeop changeop ON changeop.objkey = hypervisor.id
INNER JOIN priv_change chang ON chang.id = changeop.changeid
LEFT JOIN 
	(
		SELECT *
		FROM priv_sync_replica 
		WHERE dest_class = 'Hypervisor'
	) replica ON hypervisor.id = replica.dest_id
WHERE replica.id IS NULL AND changeop.objclass = 'Hypervisor' AND changeop.optype = 'CMDBChangeOpCreate'