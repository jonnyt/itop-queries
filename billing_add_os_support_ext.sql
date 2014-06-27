### EXT OS Support ###
SELECT
	"R" As TYPE,
	"" As `USER ID`,
	CASE
		WHEN sla_name = 'Extended OS Support' AND service_name = 'Windows Systems Administration' THEN 'W-EXT'
		WHEN sla_name = 'Extended OS Support' AND service_name = 'Linux Systems Administration' THEN 'UNIX-LINEXT'
		WHEN sla_name = 'Extended OS Support' AND service_name = 'Solaris Systems Administration' THEN 'UNIX-SIXEXT'
		ELSE 'INVALID SLA'
	END as 'ITEM ID',
	SUM(1) AS 'QTY',
	"" AS 'OVERRIDE',
	CONVERT(view_CustomerContract.cost_unit USING utf8) AS 'DEBT GL COA',
	"" AS 'START DATE',
	"" AS 'END DATE',
	CONVERT(view_lnkCustomerContractToFunctionalCI.functionalci_name USING utf8) AS 'SERVICEID DIRN',
	DATE_FORMAT(view_CustomerContract.start_date,'%Y-%m-%d') AS 'DESC 2'
FROM view_CustomerContract
	Inner Join view_lnkCustomerContractToService On view_CustomerContract.id = view_lnkCustomerContractToService.customercontract_id
	Inner Join view_lnkCustomerContractToFunctionalCI On view_CustomerContract.id = view_lnkCustomerContractToFunctionalCI.customercontract_id
	Inner Join view_VirtualMachine ON view_VirtualMachine.id = view_lnkCustomerContractToFunctionalCI.functionalci_id
WHERE (service_name = 'Windows Systems Administration' OR service_name = 'Linux Systems Administration' OR service_name = 'Solaris Systems Administration') AND
		(sla_name = 'Extended OS Support') AND view_VirtualMachine.`status` != 'Obsolete'
Group By
	`SERVICEID DIRN`