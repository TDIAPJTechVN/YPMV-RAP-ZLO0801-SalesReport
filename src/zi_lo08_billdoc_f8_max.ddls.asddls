@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'LO08: Max BillingDocument F8'
define view entity ZI_LO08_BILLDOC_F8_MAX
  as select from I_BillingDocumentItem as billitem
    inner join   I_BillingDocument     as bill on bill.BillingDocument = billitem.BillingDocument
{
  key    billitem.SalesDocument,
  key    billitem.SalesDocumentItem,
  key    billitem.ReferenceSDDocument     as ReferenceSDDocument,       //add Key by Maoko
  key    billitem.ReferenceSDDocumentItem as ReferenceSDDocumentItem,   //add Key by Maoko
         max( billitem.BillingDocument )  as BillingDocument
}
where
      bill.BillingDocumentType        = 'F8'
  and bill.BillingDocumentIsCancelled = ''
  and billitem.BillingQuantity        > 0
group by
  billitem.SalesDocument,
  billitem.SalesDocumentItem,
  billitem.ReferenceSDDocument,
  billitem.ReferenceSDDocumentItem 
  ;
