SELECT lv.id,lv.name,changeop.optype,chang.date
FROM logicalvolume lv
INNER JOIN priv_changeop changeop ON changeop.objkey = lv.id
INNER JOIN priv_change chang ON chang.id = changeop.changeid
LEFT JOIN 
	(
		SELECT *
		FROM priv_sync_replica 
		WHERE dest_class = 'LogicalVolume'
	) replica ON lv.id = replica.dest_id
WHERE replica.id IS NULL AND changeop.objclass = 'LogicalVolume' AND changeop.optype = 'CMDBChangeOpCreate'