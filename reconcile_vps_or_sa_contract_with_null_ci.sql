# Contracts for either a VPS services and/or Systems administration should always be associated
# with some CI (a VM for example).  If not, we should stop billing.

SELECT DISTINCT a.id,a.name,a.start_date,a.end_date,a.cost_unit
FROM view_CustomerContract a LEFT JOIN view_lnkCustomerContractToService b on a.id = b.customercontract_id
LEFT JOIN view_lnkCustomerContractToFunctionalCI c on a.id = c.customercontract_id
WHERE (b.service_name = 'Virtual Private Server' OR b.service_name LIKE '%Systems Administration') AND c.id IS NULL AND a.end_date IS NULL