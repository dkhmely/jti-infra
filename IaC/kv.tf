
resource "azurerm_key_vault_secret" "secret" {
  name         = "app-sql-user-password"
  value        = random_password.password.result
  key_vault_id = data.azurerm_key_vault.kv.id
}