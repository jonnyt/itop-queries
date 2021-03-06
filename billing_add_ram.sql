###  Extra RAM  ###
Select
  "R" As TYPE,
  "" As `USER ID`,
  "W-VMRAM" As `ITEM ID`,
  SUM(ROUND(view_VirtualMachine.ram - 1,0)) As QTY,
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
Group By
	`SERVICEID DIRN`