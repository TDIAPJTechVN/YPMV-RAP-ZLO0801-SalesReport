@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'LO08: I - Get bill of Commercial Invoice'
define view entity ZI_LO08_BILLOfinvoice
  as select from    ZI_LO08_BILLdoc_f2 as billf2
    left outer join ZI_LO08_BILLOFJE   as BILLJE on  BILLJE.Billingdocument     = billf2.BillingDocument
                                                 and BILLJE.BillingDocumentItem = billf2.BillingDocumentItem
{
  key billf2.ReferenceSDDocument,
  key billf2.ReferenceSDDocumentItem,
      billf2.OutboundDelivery,
      billf2.OutboundDeliveryItem,
      billf2.BillingDocument,
      billf2.BillingDocumentItem,
      BILLJE.AccountingDocument,
      BILLJE.DocumentReferenceid,
      BILLJE.Transactioncurrency         as Transactioncurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      BILLJE.AmountInTransactionCurrency as AmountInTransactionCurrency,
      BILLJE.CompanyCodeCurrency         as CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      BILLJE.AmountInCompanyCodeCurrency as AmountInCompanyCodeCurrency

}
