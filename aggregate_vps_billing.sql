###  Base VM  ####
Select
  "R" As TYPE,
  "" As `USER ID`,
  "W-VMBASE" As `ITEM ID`,
  "1" As QTY,
  "" As OVERRIDE,
  CONVERT(view_CustomerContract.cost_unit USING utf8) As `DEBT GL COA`,
  "" As `START DATE`,
  CONVERT(view_CustomerContract.end_date USING utf8) As `END DATE`,
  CONVERT(view_VirtualMachine.name USING utf8) As `SERVICEID DIRN`,
  DATE_FORMAT(view_CustomerContract.start_date,'%Y-%m-%d') As `DESC 2`
From view_CustomerContract 
	Inner Join view_lnkCustomerContractToService On view_CustomerContract.id = view_lnkCustomerContractToService.customercontract_id 
	Inner Join view_lnkCustomerContractToFunctionalCI On view_CustomerContract.id = view_lnkCustomerContractToFunctionalCI.customercontract_id
	Inner Join view_VirtualMachine On view_lnkCustomerContractToFunctionalCI.functionalci_id = view_VirtualMachine.id
Where
  view_lnkCustomerContractToService.service_name = 'Virtual Private Server' AND
  view_VirtualMachine.`status` != 'Obsolete'
UNION ALL
###  Extra CPU  ###
Select
  "R" As TYPE,
  "" As `USER ID`,
  "W-VMCPU" As `ITEM ID`,
  view_VirtualMachine.cpu - 1 As QTY,
  "" As OVERRIDE,
  CONVERT(view_CustomerContract.cost_unit USING utf8) As `DEBT GL COA`,
  "" As `START DATE`,
  CONVERT(view_CustomerContract.end_date USING utf8) As `END DATE`,
  CONVERT(view_lnkCustomerContractToFunctionalCI.functionalci_id_friendlyname USING utf8) As
  `SERVICEID DIRN`,
  DATE_FORMAT(view_CustomerContract.start_date,'%Y-%m-%d') As `DESC 2`
From view_CustomerContract 
	Inner Join view_lnkCustomerContractToService On view_CustomerContract.id = view_lnkCustomerContractToService.customercontract_id 
	Inner Join view_lnkCustomerContractToFunctionalCI On view_CustomerContract.id = view_lnkCustomerContractToFunctionalCI.customercontract_id
	Inner Join view_VirtualMachine On view_lnkCustomerContractToFunctionalCI.functionalci_id = view_VirtualMachine.id
Where
  view_lnkCustomerContractToService.service_name = 'Virtual Private Server' AND
  view_VirtualMachine.`status` != 'Obsolete' AND
  view_VirtualMachine.cpu > 1
UNION ALL
###  Extra RAM  ###
Select
  "R" As TYPE,
  "" As `USER ID`,
  "W-VMRAM" As `ITEM ID`,
  view_VirtualMachine.ram - 1 As QTY,
  "" As OVERRIDE,
  CONVERT(view_CustomerContract.cost_unit USING utf8) As `DEBT GL COA`,
  "" As `START DATE`,
  CONVERT(view_CustomerContract.end_date USING utf8) As `END DATE`,
  CONVERT(view_lnkCustomerContractToFunctionalCI.functionalci_id_friendlyname USING utf8) As
  `SERVICEID DIRN`,
  DATE_FORMAT(view_CustomerContract.start_date,'%Y-%m-%d') As `DESC 2`
From view_CustomerContract 
	Inner Join view_lnkCustomerContractToService On view_CustomerContract.id = view_lnkCustomerContractToService.customercontract_id 
	Inner Join view_lnkCustomerContractToFunctionalCI On view_CustomerContract.id = view_lnkCustomerContractToFunctionalCI.customercontract_id
	Inner Join view_VirtualMachine On view_lnkCustomerContractToFunctionalCI.functionalci_id = view_VirtualMachine.id
Where
  view_lnkCustomerContractToService.service_name = 'Virtual Private Server' AND
  view_VirtualMachine.`status` != 'Obsolete' AND
  view_VirtualMachine.ram >= 2
UNION ALL
###  Extra Storage  ###
Select
  "R" As TYPE,
  "" As `USER ID`,
  CASE 
  		WHEN view_lnkVirtualDeviceToVolume.volume_name LIKE '%-S-%' THEN 'W-VMSPERF'
		WHEN view_lnkVirtualDeviceToVolume.volume_name LIKE '%-SSD-%' THEN 'W-VMSPERF'
	  	WHEN view_lnkVirtualDeviceToVolume.volume_name LIKE '%-H-%' THEN 'W-VMSPERF'
		WHEN view_lnkVirtualDeviceToVolume.volume_name LIKE '%-L-%' THEN 'W-VMSUTIL' 
		WHEN view_lnkVirtualDeviceToVolume.volume_name LIKE '%-E-%' THEN 'W-VMSUTIL' 
		ELSE 'INVALID'
  END As `ITEM ID`,
	view_lnkVirtualDeviceToVolume.size_used As QTY,
  "" As OVERRIDE,
  CONVERT(view_CustomerContract.cost_unit USING utf8) As `DEBT GL COA`,
  "" As `START DATE`,
  CONVERT(view_CustomerContract.end_date USING utf8) As `END DATE`,
  CONVERT(view_lnkCustomerContractToFunctionalCI.functionalci_id_friendlyname USING utf8) As
  `SERVICEID DIRN`,
  DATE_FORMAT(view_CustomerContract.start_date,'%Y-%m-%d') As `DESC 2`
From view_CustomerContract 
	Inner Join view_lnkCustomerContractToService On view_CustomerContract.id = view_lnkCustomerContractToService.customercontract_id 
	Inner Join view_lnkCustomerContractToFunctionalCI On view_CustomerContract.id = view_lnkCustomerContractToFunctionalCI.customercontract_id
	Inner Join view_VirtualMachine On view_lnkCustomerContractToFunctionalCI.functionalci_id = view_VirtualMachine.id
	Inner Join view_lnkVirtualDeviceToVolume On view_lnkVirtualDeviceToVolume.virtualdevice_id = view_VirtualMachine.id
Where
  (view_lnkCustomerContractToService.service_name = 'Virtual Private Server' OR view_lnkCustomerContractToService.service_name = 'VM Template' ) AND
	view_VirtualMachine.`status` != 'Obsolete'
UNION ALL
### OS Support ###
SELECT
	"R" As TYPE,
	"" As `USER ID`,
	CASE
		WHEN sla_name = 'Standard OS Support' AND service_name = 'Windows Systems Administration' THEN 'W-STD'
		WHEN sla_name = 'Standard OS Support' AND service_name = 'Linux Systems Administration' THEN 'UNIX-LINSTD'
		WHEN sla_name = 'Extended OS Support' AND service_name = 'Windows Systems Administration' THEN 'W-EXT'
		WHEN sla_name = 'Extended OS Support' AND service_name = 'Linux Systems Administration' THEN 'UNIX-LINEXT'
		WHEN sla_name = 'Standard OS Support' AND service_name = 'Solaris Systems Administration' THEN 'UNIX-SIXSTD'
		WHEN sla_name = 'Extended OS Support' AND service_name = 'Solaris Systems Administration' THEN 'UNIX-SIXEXT'
		ELSE 'INVALID SLA'
	END as 'ITEM ID',
	1 AS 'QTY',
	"" AS 'OVERRIDE',
	CONVERT(view_CustomerContract.cost_unit USING utf8) AS 'DEBT GL COA',
	"" AS 'START DATE',
	"" AS 'END DATE',
	CONVERT(view_lnkCustomerContractToFunctionalCI.functionalci_name USING utf8) AS 'SERVICEID DIRN',
	DATE_FORMAT(view_CustomerContract.start_date,'%Y-%m-%d') AS 'DESC 2'
FROM view_CustomerContract
	Inner Join view_lnkCustomerContractToService On view_CustomerContract.id = view_lnkCustomerContractToService.customercontract_id
	Inner Join view_lnkCustomerContractToFunctionalCI On view_CustomerContract.id = view_lnkCustomerContractToFunctionalCI.customercontract_id
WHERE service_name = 'Windows Systems Administration' OR service_name = 'Linux Systems Administration' OR service_name = 'Solaris Systems Administration'