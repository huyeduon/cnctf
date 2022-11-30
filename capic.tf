terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">3.32.0"
    }
  }
}

# Provider in subs huyeduon-Demo04
provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {
    template_deployment {
      delete_nested_items_during_deletion = false
    }
  }
}

# Deploy a resource group
resource "azurerm_resource_group" "rgroup" {
  name     = var.rgName
  location = var.location
}

# Deploy cAPIC from ARM template
resource "azurerm_resource_group_template_deployment" "capic03" {
  depends_on          = [azurerm_resource_group.rgroup]
  name                = var.deployName
  resource_group_name = azurerm_resource_group.rgroup.name
  deployment_mode     = "Incremental"
  template_content    = file("template.json")
  parameters_content = jsonencode({
    location                 = { value = var.location }
    _artifactsLocation       = { value = "https://catalogartifact.azureedge.net/publicartifacts/cisco.cisco-aci-cloud-apic-15c113a3-5e97-434d-802f-c1b4543b9e1f-25_1_1-byol/Artifacts/mainTemplate.json" }
    adminPasswordOrKey       = { value = "123Cisco123!" }
    adminPublicKey           = { value = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDA6CI26ym4VD1PWBq83rx3zbHsn8Ky668ALZfG8z17vDeu6skxb41qPQyL80ovesQx+avrh/kiNhm+Nt87XYTcnaG03wj6NB5jwCvD8vIVKPULximDUxfxA8lp9DgjNdiUSyys2Mt2NVzT7J9vGKpnIK3FxrMW7RkDXBb6N8NCbyvu5d+QVFsbjej5neOAfSR7YJSDLhy2bUrZqKVefOkUeHiufo+hPqObMCYjc5GULV+cqTUTW2ippHtCKXTyYJudiJAaWFiWYcNiupH91LRvOABIQk38CX3OlnvG3ab+mUJq6XGMEKPJMlxI+cQBkjn2oKa8I8s43vyfsp6xwFjL" }
    location                 = { value = "eastus" }
    vmName                   = { value = "capictf" }
    vmSize                   = { value = "Standard_D8s_v3" }
    imageSku                 = { value = "25_1_1-byol" }
    imageVersion             = { value = "latest" }
    adminUsername            = { value = "capicuser" }
    fabricName               = { value = "Cloud-Fabric" }
    infraVNETPool            = { value = "10.33.0.0/24" }
    externalSubnets          = { value = "0.0.0.0/0" }    
    publicIpDns              = { value = "cloudapic-34cda40cd" }
    publicIPName             = { value = "CloudAPIC-pip" }
    publicIPSku              = { value = "Standard" }
    publicIPAllocationMethod = { value = "Static" }
    publicIPNewOrExisting    = { value = "new" }
    publicIPResourceGroup    = { value = "capic03" }
    virtualNetworkName       = { value = "overlay-1" }
    mgmtNsgName              = { value = "controllers_cloudapp-cloud-infra" }
    mgmtAsgName              = { value = "controllers_cloudapp-cloud-infra" }
    subnetPrefix             = { value = "subnet-" }
  })
}
