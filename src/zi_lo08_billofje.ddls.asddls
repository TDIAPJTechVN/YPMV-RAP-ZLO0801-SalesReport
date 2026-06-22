@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'LO08: I - Get bill with JE (summed)'
define view entity ZI_LO08_BILLOFJE
  as select from    I_BillingDocument     as Billhdr
    inner join      I_BillingDocumentItem as Billitm          on Billitm.BillingDocument = Billhdr.BillingDocument
    inner join      I_JournalEntry        as JournalEntry     on Billhdr.BillingDocument = JournalEntry.OriginalReferenceDocument
    left outer join I_JournalEntryItem    as JournalEntryItem on  JournalEntryItem.AccountingDocument    = JournalEntry.AccountingDocument
                                                              and JournalEntryItem.ReferenceDocument     = Billitm.BillingDocument
                                                              and JournalEntryItem.ReferenceDocumentItem = Billitm.BillingDocumentItem
                                                              and JournalEntryItem.Ledger                = '0L' // keep LEFT OUTER
{
  key Billhdr.BillingDocument              as BillingDocument,
  key Billitm.BillingDocumentItem          as BillingDocumentItem,
      JournalEntry.AccountingDocument      as AccountingDocument,
      JournalEntry.DocumentReferenceID     as DocumentReferenceID,
      JournalEntryItem.TransactionCurrency as TransactionCurrency,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum(
        case
          when JournalEntryItem.AmountInTransactionCurrency < 0
            then JournalEntryItem.AmountInTransactionCurrency * -1
          else JournalEntryItem.AmountInTransactionCurrency
        end
      )                                    as AmountInTransactionCurrency,

      JournalEntryItem.CompanyCodeCurrency as CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(
        case
          when JournalEntryItem.AmountInCompanyCodeCurrency < 0
            then JournalEntryItem.AmountInCompanyCodeCurrency * -1
          else JournalEntryItem.AmountInCompanyCodeCurrency
        end
      )                                    as AmountInCompanyCodeCurrency
}
group by
  Billhdr.BillingDocument,
  Billitm.BillingDocumentItem,
  JournalEntry.AccountingDocument,
  JournalEntry.DocumentReferenceID,
  JournalEntryItem.TransactionCurrency,
  JournalEntryItem.CompanyCodeCurrency;
