# This query will show all VMs that *should* have an contract that do not
# This is based on their location in vCenter and the corresponding contract on the hypervisor
SELECT DISTINCT vm.name,vm.inventory_path,vm.virtualhost_name,server.location_name
FROM view_VirtualMachine vm 
	LEFT JOIN view_lnkCustomerContractToFunctionalCI lnkCustomerContractToCI ON lnkCustomerContractToCI.functionalci_id = vm.id
	LEFT JOIN view_CustomerContract customerContract ON customerContract.id = lnkCustomerContractToCI.customercontract_id
	LEFT JOIN view_Hypervisor hypervisor ON vm.virtualhost_id = hypervisor.id
	LEFT JOIN
		(
			SELECT lnkContractToCI.functionalci_id,lnkContractToCI.customercontract_name,lnkCutomerContractToSvc.service_name
			FROM view_Hypervisor hypervisor
				JOIN view_lnkCustomerContractToFunctionalCI lnkContractToCI ON lnkContractToCI.functionalci_id = hypervisor.id
				JOIN view_lnkCustomerContractToService lnkCutomerContractToSvc ON lnkCutomerContractToSvc.customercontract_id = lnkContractToCI.customercontract_id
		) multiTenantClusterContracts ON multiTenantClusterContracts.functionalci_id = hypervisor.id
	LEFT JOIN view_Server server ON hypervisor.server_id = server.id
WHERE lnkCustomerContractToCI.customercontract_id IS NULL 
	AND multiTenantClusterContracts.service_name LIKE '%Multitenant Cluster%'
	AND vm.status != 'implementation'
	AND vm.status != 'stock'
	AND vm.status != 'obsolete'
ORDER BY vm.name