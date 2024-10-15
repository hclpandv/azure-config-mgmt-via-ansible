#!/usr/bin/python

from ansible.module_utils.basic import AnsibleModule
import azure.identity
import azure.mgmt.compute

def invoke_azurerm_vm_run_command(run_command,vm_name,vm_resource_group,subscription_id,tenant_id=None,client_id=None,client_secret=None,use_msi=False):
    '''Read Azure keyvault secret'''
    if use_msi:
        credential=azure.identity.ManagedIdentityCredential()
    else:
        credential=azure.identity.ClientSecretCredential(tenant_id,client_id,client_secret)

    compute_client = azure.mgmt.compute.ComputeManagementClient(credential=credential, subscription_id=subscription_id)
    
    # Execute a PowerShell command on the VM via run command
    run_command_parameters = {
        'command_id': 'RunPowerShellScript',
        'script': [
            run_command
        ]
    }
    
    async_run_command = compute_client.virtual_machines.begin_run_command(
        resource_group_name=vm_resource_group,
        vm_name=vm_name,
        parameters=run_command_parameters
    )

    return async_run_command.result().value[0].message


def main():
    '''Main def to invoke ansible module'''
    arguments = dict(
            run_command=dict(required=True),
            vm_name=dict(required=True),
            vm_resource_group=dict(required=True),
            subscription_id=dict(required=True),
            tenant_id=dict(required=False),
            client_id=dict(required=False),
            client_secret=dict(required=False,no_log=True),
            use_msi=dict(required=False)
    )

    result = dict(
        changed=False,
        original_message='',
        message=''
    )

    module = AnsibleModule(
        argument_spec=arguments,
        supports_check_mode=True
    )

    if module.check_mode:
        module.exit_json(changed=True)

    if module.params['use_msi']:
        result['original_message'] = invoke_azurerm_vm_run_command(
            module.params['run_command'],
            module.params['vm_name'],
            module.params['vm_resource_group'],
            module.params['subscription_id'],
            user_msi=True
        )
    else:
        result['original_message'] = invoke_azurerm_vm_run_command(
            module.params['run_command'],
            module.params['vm_name'],
            module.params['vm_resource_group'],
            module.params['subscription_id'],
            module.params['tenant_id'],
            module.params['client_id'],
            module.params['client_secret']
        )
    
    result['message'] = 'testing azure rm scripts'

    # OUTPUT
    module.exit_json(**result)


if __name__ == '__main__':
    main()