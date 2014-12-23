SELECT *
FROM priv_sync_replica replica
LEFT JOIN
	(
		SELECT syncds.id,syncds.name,syncds.scope_class FROM priv_sync_datasource syncds
	) source ON replica.sync_source_id = source.id
WHERE source.id IS NULL