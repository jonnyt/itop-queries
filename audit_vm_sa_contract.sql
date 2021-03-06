# This query will show all VMs that *should* have an SA contract that do not
# This is based on:
#			Location in vCenter (managed folders)
#			Not being a template (status=stock)
#			Not being a DEV machine (status=implementation)

SELECT vm.name,vm.status,vm.inventory_path,vm.virtualhost_name,server.location_name,lnkCustomerContractToCI.customercontract_name
FROM view_VirtualMachine vm 
	LEFT JOIN view_lnkCustomerContractToFunctionalCI lnkCustomerContractToCI ON lnkCustomerContractToCI.functionalci_id = vm.id
	LEFT JOIN
		(
			SELECT customerContract.id,customerContract.name,service_name
			FROM view_CustomerContract customerContract 
				JOIN view_lnkCustomerContractToService lnkCutomerContractToSvc ON lnkCutomerContractToSvc.customercontract_id = customerContract.id
			WHERE service_name LIKE '%Systems Administration'
		) sysAdminContracts ON sysAdminContracts.id = lnkCustomerContractToCI.customercontract_id
	LEFT JOIN view_Hypervisor hypervisor ON vm.virtualhost_id = hypervisor.id
	LEFT JOIN view_Server server ON hypervisor.server_id = server.id
WHERE vm.inventory_path LIKE "%/Managed%"
	AND sysAdminContracts.id IS NULL 
	AND vm.status != 'implementation'
	AND vm.status != 'stock'
	AND vm.status != 'obsolete'
	AND vm.inventory_path NOT LIKE "%/XenApp Servers%"
ORDER BY name