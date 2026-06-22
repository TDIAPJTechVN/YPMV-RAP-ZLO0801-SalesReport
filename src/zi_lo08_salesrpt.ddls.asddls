@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LO08: I - sales report' 
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
define root view entity zi_lo08_salesrpt
  as select from    I_SalesDocumentItem        as salesitm
    inner join      I_SalesDocument            as saleshdr           on saleshdr.SalesDocument = salesitm.SalesDocument

    left outer join ZI_LO08_outboundeliveryitm as obitm              on  obitm.ReferenceSDDocument     = salesitm.SalesDocument
                                                                     and obitm.ReferenceSDDocumentItem = salesitm.SalesDocumentItem
    left outer join ZI_LO08_BILLDOC_f8         as billdoc_F8         on  billdoc_F8.ReferenceSDDocument     = salesitm.SalesDocument
                                                                     and billdoc_F8.ReferenceSDDocumentItem = salesitm.SalesDocumentItem
                                                                     and billdoc_F8.OutboundDelivery        = obitm.OutboundDelivery
                                                                     and billdoc_F8.OutboundDeliveryItem    = obitm.OutboundDeliveryItem
    left outer join ZI_LO08_BILLOfinvoice      as lo08_BILLOfinvoice on  lo08_BILLOfinvoice.ReferenceSDDocument     = salesitm.SalesDocument
                                                                     and lo08_BILLOfinvoice.ReferenceSDDocumentItem = salesitm.SalesDocumentItem
                                                                     and lo08_BILLOfinvoice.OutboundDelivery        = obitm.OutboundDelivery
                                                                     and lo08_BILLOfinvoice.OutboundDeliveryItem    = obitm.OutboundDeliveryItem
    left outer join I_BillingDocumentItem      as billtax            on  billtax.BillingDocument     = lo08_BILLOfinvoice.BillingDocument
                                                                     and billtax.BillingDocumentItem = lo08_BILLOfinvoice.BillingDocumentItem
    left outer join I_Customer                 as sold               on sold.Customer = salesitm.SoldToParty
    left outer join I_Customer                 as ship               on ship.Customer = salesitm.ShipToParty
    left outer join zi_lo08_stocksumbyproduct  as sumproduct         on sumproduct.Product = salesitm.Product
    left outer join I_BusinessPartner          as soldname           on soldname.BusinessPartner = salesitm.SoldToParty
    left outer join I_BusinessPartner          as shipname           on shipname.BusinessPartner = salesitm.ShipToParty

{

  key  salesitm.SalesDocument                         as SalesDocument,
  key  salesitm.SalesDocumentItem                     as SalesDocumentItem,
  key  obitm.OutboundDelivery                         as OutboundDelivery,
  key  obitm.OutboundDeliveryItem                     as OutboundDeliveryItem,
  key  billdoc_F8.BillingDocument                     as BillingDocumentLading,     //add key by maoko
  key  billdoc_F8.BillingDocumentItem                 as BillingDocumentItemLading, //add key by maoko
  key  lo08_BILLOfinvoice.BillingDocument             as BillingDocumentInv,        //add key by maoko
  key  lo08_BILLOfinvoice.BillingDocumentItem         as BillingDocumentItemInv,    //add key by maoko
       salesitm.PurchaseOrderByCustomer               as PurchaseOrderByCustomer,
       saleshdr.SalesDocumentType                     as SalesDocumentType,
       saleshdr.SoldToParty                           as SoldToParty,
       salesitm.Product                               as Product,
       salesitm.ShipToParty                           as ShipToParty,
       salesitm.SalesDocumentItemText                 as SalesDocumentItemText,
       salesitm.OrderQuantityUnit                     as OrderQuantityUnit,
       @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
       salesitm.OrderQuantity                         as OrderQuantity,
       salesitm.TransactionCurrency                   as TransactionCurrency,
       @Semantics.amount.currencyCode: 'TransactionCurrency'
       salesitm.NetPriceAmount                        as NetPriceAmount,
       obitm.DeliveryQuantityUnit                     as DeliveryQuantityUnit,
       @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
       obitm.OriginalDeliveryQuantity                 as OriginalDeliveryQuantity,

       obitm.DeliveryDate                             as DeliveryDate,
       obitm.Actualgoodsmovementdate                  as Actualgoodsmovementdate,
       obitm.BillofLading                             as BillofLading,
       obitm.Deliverydocumentbysupplier               as Deliverydocumentbysupplier,
       
       lo08_BILLOfinvoice.AccountingDocument          as AccountingDocumentINV,
       lo08_BILLOfinvoice.DocumentReferenceid         as DocumentReferenceidINV,
       lo08_BILLOfinvoice.Transactioncurrency         as TransactioncurrencyINV,
       @Semantics.amount.currencyCode: 'TransactionCurrencyINV'
       lo08_BILLOfinvoice.AmountInTransactionCurrency as AmountInTransactionCurrencyINV,
       lo08_BILLOfinvoice.CompanyCodeCurrency         as CompanyCodeCurrencyINV,
       @Semantics.amount.currencyCode: 'CompanyCodeCurrencyINV'
       lo08_BILLOfinvoice.AmountInCompanyCodeCurrency as AmountInCompanyCodeCurrencyINV,

       //Update ver.01
       sold.OrganizationBPName2                       as BPName_sold,
       ship.OrganizationBPName2                       as BPName_ship,
       saleshdr.SalesOrganization,
       saleshdr.DistributionChannel                   as Channel,
       saleshdr.OrganizationDivision                  as division,
       salesitm.ProfitCenter,
       @Semantics.amount.currencyCode: 'TransactionCurrency'
       billtax.TaxAmount,
       sumproduct.MaterialBaseUnit,
       @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
       sumproduct.StockQtyInBaseUnit,

       //Update 08/01/26
       obitm.plandate,
       obitm.obhdr_status,

       //Update 12/01/26
       //       concat( concat( concat_with_space(soldname.OrganizationBPName1, soldname.OrganizationBPName2, 1) , soldname.OrganizationBPName3 ), soldname.OrganizationBPName4 ) as soldName,
       //       concat( concat( concat( shipname.OrganizationBPName1, shipname.OrganizationBPName2 ), shipname.OrganizationBPName3 ), shipname.OrganizationBPName4 ) as shipName
       concat_with_space(
         concat_with_space(
           concat_with_space( soldname.OrganizationBPName1, soldname.OrganizationBPName2, 1 ),
           soldname.OrganizationBPName3, 1 ),
         soldname.OrganizationBPName4, 1
       )                                              as SoldName,
       concat_with_space(
         concat_with_space(
           concat_with_space( shipname.OrganizationBPName1, shipname.OrganizationBPName2, 1 ),
           shipname.OrganizationBPName3, 1 ),
         shipname.OrganizationBPName4, 1
       )                                              as shipName

}
where
      obitm.OutboundDelivery     is not initial
  and obitm.OutboundDeliveryItem is not initial
