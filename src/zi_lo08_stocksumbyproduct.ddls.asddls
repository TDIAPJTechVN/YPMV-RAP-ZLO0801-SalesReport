@AbapCatalog.sqlViewName: 'ZI_LO08_STOCKSU'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LO08: Stock sum by Product'
@Metadata.ignorePropagatedAnnotations: true
define view zi_lo08_stocksumbyproduct
  as select from I_StockQuantityCurrentValue_2(
                   P_DisplayCurrency: 'VND'
                 )                   as ST
//    inner join   I_SalesDocumentItem as P on P.Product = ST.Product
  //{
  //  key ST.Product,
  //      ST.MaterialBaseUnit,
  //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  //      sum( ST.MatlWrhsStkQtyInMatlBaseUnit ) as StockQtyInBaseUnit
  //}
  //where
  //      ST.Plant              = '5730'
  //  and ST.StorageLocation    = '9440'
  //  and ST.InventoryStockType = '01'
  //group by
  //  ST.Product,
  //  ST.MaterialBaseUnit;

{
  key ST.Product,
      ST.Plant,
      ST.StorageLocation,
      ST.InventoryStockType,
      ST.ValuationAreaType,

      ST.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum( ST.MatlWrhsStkQtyInMatlBaseUnit ) as StockQtyInBaseUnit
}
where
      ST.Plant              = '5730'
  and ST.StorageLocation    = '9440'
  and ST.InventoryStockType = '01'
  and ST.ValuationAreaType  = '1'
group by
  ST.Product,
  ST.Plant,
  ST.StorageLocation,
  ST.InventoryStockType,
  ST.ValuationAreaType,
  ST.MaterialBaseUnit;
