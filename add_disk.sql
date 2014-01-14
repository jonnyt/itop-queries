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