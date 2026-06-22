@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LO08: C - sales report' 
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZC_LO08_SALESRPT
  as projection on zi_lo08_salesrpt
{
  key SalesDocument,
  key SalesDocumentItem,
  key OutboundDelivery,
  key OutboundDeliveryItem,
  key BillingDocumentLading,     //add key by maoko
  key BillingDocumentItemLading, //add key by maoko
  key BillingDocumentInv,        //add key by maoko
  key BillingDocumentItemInv,    //add key by maoko
      
      PurchaseOrderByCustomer,
      SalesDocumentType,
      ShipToParty,
      SoldToParty,
      Product,
      SalesDocumentItemText,
      OrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      OrderQuantity,
      TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      NetPriceAmount,

      DeliveryQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
      OriginalDeliveryQuantity,
      DeliveryDate,
      Actualgoodsmovementdate,
      BillofLading,
      
      Deliverydocumentbysupplier,
      
      AccountingDocumentINV,
      DocumentReferenceidINV,
      TransactioncurrencyINV,
      @Semantics.amount.currencyCode: 'TransactionCurrencyINV'
      AmountInTransactionCurrencyINV,
      CompanyCodeCurrencyINV,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrencyINV'
      AmountInCompanyCodeCurrencyINV,

      //update ver0.1
      BPName_sold,
      BPName_ship,
      SalesOrganization,
      Channel,
      division,
      ProfitCenter,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TaxAmount,
      MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      StockQtyInBaseUnit,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_LO08_SALES_VIR'
      @EndUserText.label: 'Batch No'
      virtual ZBatch   : abap.char(30),
      
       plandate,
       obhdr_status,
       SoldName,
       shipName
}
