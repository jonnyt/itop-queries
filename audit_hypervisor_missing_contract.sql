# This query will show all ESXi hosts missing a Customer Contract and
# either the Dedicated Cluster or Multitenant Cluster service
SELECT hypervisor.name,hypervisor.farm_name as 'cluster_name'
FROM view_Hypervisor hypervisor
	LEFT JOIN view_lnkCustomerContractToFunctionalCI lnkCustomerContractToCI ON lnkCustomerContractToCI.functionalci_id = hypervisor.id
	LEFT JOIN
		(
			SELECT cuscontract.id,cuscontract.name,service_name
			FROM view_CustomerContract cuscontract 
				LEFT JOIN view_lnkCustomerContractToService lnkCutomerContractToSvc ON lnkCutomerContractToSvc.customercontract_id = cuscontract.id
			WHERE service_name LIKE '%ESXi Multitenant Cluster' OR service_name LIKE '%ESXi Dedicated Cluster'
		) esxiContracts ON esxiContracts.id = lnkCustomerContractToCI.customercontract_id
WHERE esxiContracts.service_name IS NULL AND hypervisor.status != 'obsolete'
ORDER BY hypervisor.name