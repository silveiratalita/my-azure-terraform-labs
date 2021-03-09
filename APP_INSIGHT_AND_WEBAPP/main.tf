resource "azurerm_resource_group" "talita" {
  name     = "Talita"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "talita" {
  name                = "example-appserviceplan-talita"
  location            = azurerm_resource_group.talita.location
  resource_group_name = azurerm_resource_group.talita.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "talita" {
  name                = "talita-app-service"
  location            = azurerm_resource_group.talita.location
  resource_group_name = azurerm_resource_group.talita.name
  app_service_plan_id = azurerm_app_service_plan.talita.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}

resource "azurerm_application_insights" "talita" {
  name                = "tf-talita-appinsights"
  location            = azurerm_resource_group.talita.location
  resource_group_name = azurerm_resource_group.talita.name
  application_type    = "web"
}

output "instrumentation_key" {
  value = azurerm_application_insights.talita.instrumentation_key
}

output "app_id" {
  value = azurerm_application_insights.talita.app_id
}