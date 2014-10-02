# Contracts for either a VPS services and/or Systems administration should always be associated
# with some CI (a VM for example).  If not, we should stop billing.

SELECT a.id,a.name,a.start_date,a.end_date,a.cost_unit,c.name,c.`status`
FROM view_CustomerContract a JOIN view_lnkCustomerContractToFunctionalCI b on a.id = b.customercontract_id
JOIN view_VirtualMachine c on b.functionalci_id = c.id
WHERE c.status = 'obsolete' and a.end_date IS NULL