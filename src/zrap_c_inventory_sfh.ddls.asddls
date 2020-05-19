@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forInventory'
define root view entity ZRAP_C_INVENTORY_SFH
  as projection on ZRAP_I_INVENTORY_SFH
{
  key Uuid as Uuid,
  
  InventoryId as InventoryId,
  
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZRAP_CE_PRODUCTS_SFH', element: 'Product' }}]
  ProductId as ProductId,
  
  Quantity as Quantity,
  
  QuantityUnit as QuantityUnit,
  
  QuantityInWords as QuantityInWords,
  
  Remark as Remark,
  
  NotAvailable as NotAvailable,
  
  CreatedBy as CreatedBy,
  
  CreatedAt as CreatedAt,
  
  LastChangedBy as LastChangedBy,
  
  LastChangedAt as LastChangedAt
}
