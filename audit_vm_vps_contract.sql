# This query will show all VMs that *should* have an contract that do not
# This is based on their location in vCenter for now.
SELECT vm.name,vm.status,vm.inventory_path,vm.virtualhost_name,lnkCustomerContractToCI.customercontract_name
FROM view_VirtualMachine vm 
	LEFT JOIN view_lnkCustomerContractToFunctionalCI lnkCustomerContractToCI ON lnkCustomerContractToCI.functionalci_id = vm.id
	LEFT JOIN view_CustomerContract customerContract ON customerContract.id = lnkCustomerContractToCI.customercontract_id
WHERE lnkCustomerContractToCI.customercontract_id IS NULL AND vm.status != 'implementation' AND vm.`status` != 'obsolete'