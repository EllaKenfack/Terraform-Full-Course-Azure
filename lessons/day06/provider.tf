terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 4.8.0"
    }
  }

  required_version = ">=1.9.0"
}

provider "azurerm" {
    features {
      
    }
    subscription_id = "f229c625-10aa-43e8-87b6-4d254497b238"
}
  
