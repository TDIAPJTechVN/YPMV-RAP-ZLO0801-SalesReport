@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'LO08: I - Get bill max with F2'
define view entity ZI_LO08_BILLdoc_f2
  //  as select from I_BillingDocumentItem      as billitem
  //    inner join   ZI_LO08_outboundeliveryitm as obitem on  obitem.ReferenceSDDocument     = billitem.SalesDocument
  //                                                      and obitem.ReferenceSDDocumentItem = billitem.SalesDocumentItem
  //                                                      and obitem.OutboundDelivery        = billitem.ReferenceSDDocument
  ////                                                      and obitem.OutboundDeliveryItem    = billitem.ReferenceSDDocumentItem
  //    inner join   I_BillingDocument          as bill   on bill.BillingDocument = billitem.BillingDocument
  as select from ZI_LO08_outboundeliveryitm as obitem
    inner join   ZI_LO08_BILLDOC_F2_MAX     as maxbill  on  obitem.ReferenceSDDocument     = maxbill.SalesDocument
                                                        and obitem.ReferenceSDDocumentItem = maxbill.SalesDocumentItem
                                                        and obitem.OutboundDelivery        = maxbill.ReferenceSDDocument
//                                                      Add By thien.nt 15/06/2026 fix dupicate data
                                                        ----------------------------------- 
                                                        and obitem.OutboundDeliveryItem    = maxbill.ReferenceSDDocumentItem 
                                                        -----------------------------------  
    inner join   I_BillingDocumentItem      as billitem on  billitem.BillingDocument         = maxbill.BillingDocument
                                                        and billitem.ReferenceSDDocument     = maxbill.ReferenceSDDocument
                                                        and billitem.ReferenceSDDocumentItem = maxbill.ReferenceSDDocumentItem
{
  key obitem.ReferenceSDDocument,
  key obitem.ReferenceSDDocumentItem,
      obitem.OutboundDelivery,
      obitem.OutboundDeliveryItem,
      maxbill.BillingDocument,
      billitem.BillingDocumentItem
}
