SELECT ci.id,ci.name,vm.inventory_path,changeop.optype,chang.date
FROM virtualmachine vm
INNER JOIN functionalci ci ON vm.id = ci.id
INNER JOIN priv_changeop changeop ON changeop.objkey = vm.id
INNER JOIN priv_change chang ON chang.id = changeop.changeid
LEFT JOIN 
	(
		SELECT *
		FROM priv_sync_replica 
		WHERE dest_class = 'VirtualMachine'
	) replica ON vm.id = replica.dest_id
WHERE replica.id IS NULL AND changeop.objclass = 'VirtualMachine' AND changeop.optype = 'CMDBChangeOpCreate'