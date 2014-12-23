SELECT customerContract.id,vm.name,vm.inventory_path,vm.virtualhost_name,server.location_name
FROM view_VirtualMachine vm 
	JOIN view_lnkCustomerContractToFunctionalCI lnkCustomerContractToCI ON lnkCustomerContractToCI.functionalci_id = vm.id
	JOIN view_CustomerContract customerContract ON customerContract.id = lnkCustomerContractToCI.customercontract_id
	JOIN view_lnkCustomerContractToService ON view_lnkCustomerContractToService.customercontract_id = customerContract.id
	LEFT JOIN view_Hypervisor hypervisor ON vm.virtualhost_id = hypervisor.id
	LEFT JOIN
		(
			SELECT lnkContractToCI.functionalci_id,lnkContractToCI.customercontract_name,lnkCutomerContractToSvc.service_name
			FROM view_Hypervisor hypervisor
				JOIN view_lnkCustomerContractToFunctionalCI lnkContractToCI ON lnkContractToCI.functionalci_id = hypervisor.id
				JOIN view_lnkCustomerContractToService lnkCutomerContractToSvc ON lnkCutomerContractToSvc.customercontract_id = lnkContractToCI.customercontract_id
			WHERE lnkCutomerContractToSvc.service_name LIKE '%Multitenant Cluster%'
		) multiTenantClusterContracts ON multiTenantClusterContracts.functionalci_id = hypervisor.id
	LEFT JOIN view_Server server ON hypervisor.server_id = server.id
WHERE
	view_lnkCustomerContractToService.service_name = "Virtual Private Server" AND
	multiTenantClusterContracts.functionalci_id IS NULL