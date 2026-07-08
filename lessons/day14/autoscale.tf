resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = "${local.resource_naming.vmss_name}-autoscale"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  target_resource_id  = azurerm_orchestrated_virtual_machine_scale_set.vmss_terraform_tutorial.id
  enabled             = true
  tags                = local.common_tags

  profile {
    name = "autoscale-profile"

    capacity {
      default = var.default_instances
      minimum = var.min_instances
      maximum = var.max_instances
    }

    rule {
      metric_trigger {
        metric_name              = "Percentage CPU"
        metric_resource_id       = azurerm_orchestrated_virtual_machine_scale_set.vmss_terraform_tutorial.id
        time_grain               = "PT1M"
        statistic                = "Average"
        time_window              = "PT5M"
        time_aggregation         = "Average"
        operator                 = "GreaterThan"
        threshold                = 80
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name              = "Percentage CPU"
        metric_resource_id       = azurerm_orchestrated_virtual_machine_scale_set.vmss_terraform_tutorial.id
        time_grain               = "PT1M"
        statistic                = "Average"
        time_window              = "PT5M"
        time_aggregation         = "Average"
        operator                 = "LessThan"
        threshold                = 10
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}