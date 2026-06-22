@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'LO08: Max BillingDocument F2'
define view entity ZI_LO08_BILLDOC_F2_MAX
  as select from I_BillingDocumentItem as billitem
    inner join   I_BillingDocument     as bill on bill.BillingDocument = billitem.BillingDocument
{
  key    billitem.SalesDocument,
  key    billitem.SalesDocumentItem,
         billitem.ReferenceSDDocument     as ReferenceSDDocument,
         billitem.ReferenceSDDocumentItem as ReferenceSDDocumentItem,
         max( billitem.BillingDocument )  as BillingDocument
}
where
      bill.BillingDocumentType        = 'F2'
  and bill.BillingDocumentIsCancelled = ''
  and billitem.BillingQuantity        > 0
group by
  billitem.SalesDocument,
  billitem.SalesDocumentItem,
  billitem.ReferenceSDDocument,
  billitem.ReferenceSDDocumentItem
  ;
