variable "prefix" {
    default = "day17"
    type = string
}

variable "enable_source_control" {
  description = "Enable App Service GitHub source control integration. Requires a configured GitHub token in Azure."
  type        = bool
  default     = false
}

resource "azurerm_resource_group" "rg" {
  name = "${var.prefix}-rg"
  location = "canadacentral"
}
resource "azurerm_app_service_plan" "asp" {
  name                = "${var.prefix}-asp"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "as" {
  name                = "${var.prefix}-webappElla"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  app_service_plan_id = "${azurerm_app_service_plan.asp.id}"
}

resource "azurerm_app_service_slot" "slot" {
  name                = "${var.prefix}-staging"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  app_service_plan_id = "${azurerm_app_service_plan.asp.id}"
  app_service_name    = "${azurerm_app_service.as.name}"
}

resource "azurerm_app_service_source_control" "scm" {
  count = var.enable_source_control ? 1 : 0

  app_id   = azurerm_app_service.as.id
  repo_url = "https://github.com/EllaKenfack/tf-sample-bg"
  branch   = "master"
}

resource "azurerm_app_service_source_control_slot" "scm1" {
  count = var.enable_source_control ? 1 : 0

  slot_id   = azurerm_app_service_slot.slot.id
  repo_url = "https://github.com/EllaKenfack/tf-sample-bg"
  branch   = "appServiceSlot_Working_DO_NOT_MERGE"
}

resource "azurerm_web_app_active_slot" "active" {
  slot_id = azurerm_app_service_slot.slot.id

}