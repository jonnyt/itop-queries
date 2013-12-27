Select
  "R" As TYPE,
  "" As `USER ID`,
  "W-VMBASE" As `ITEM ID`,
  "1" As QTY,
  "" As OVERRIDE,
  view_CustomerContract.cost_unit As `DEBT GL COA`,
  DATE_FORMAT(view_CustomerContract.start_date,'%Y-%m-%d') As `START DATE`,
  view_CustomerContract.end_date As `END DATE`,
  view_lnkCustomerContractToFunctionalCI.functionalci_id_friendlyname As
  `SERVICEID DIRN`,
  "" As `DESC 2`
From view_CustomerContract 
	Inner Join view_lnkCustomerContractToService On view_CustomerContract.id = view_lnkCustomerContractToService.customercontract_id 
	Inner Join view_lnkCustomerContractToFunctionalCI On view_CustomerContract.id = view_lnkCustomerContractToFunctionalCI.customercontract_id
	Inner Join view_VirtualMachine On view_lnkCustomerContractToFunctionalCI.functionalci_id = view_VirtualMachine.id
Where
  view_lnkCustomerContractToService.service_name = 'Virtual Private Server' AND
  view_VirtualMachine.`status` != 'Obsolete'