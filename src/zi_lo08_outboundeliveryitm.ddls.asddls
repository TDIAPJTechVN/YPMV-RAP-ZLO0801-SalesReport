@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'LO08: I - Get OB'
define view entity ZI_LO08_outboundeliveryitm
  as select from    I_OutboundDeliveryItem as obitem
    inner join      I_OutboundDelivery     as obhdr  on obhdr.OutboundDelivery = obitem.OutboundDelivery
    left outer join ZI_LO08_OBITM_higher   as obhigh on  obhigh.OutboundDelivery         = obitem.OutboundDelivery
                                                     and obhigh.HigherLvlItmOfBatSpltItm = obitem.OutboundDeliveryItem

{
  key obitem.OutboundDelivery,
  key obitem.OutboundDeliveryItem,
      obitem.ReferenceSDDocument,
      obitem.ReferenceSDDocumentItem,
      obitem.DeliveryQuantityUnit      as DeliveryQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
      //      obitem.ActualDeliveryQuantity    as OriginalDeliveryQuantity,
      case
        when obitem.ActualDeliveryQuantity = 0
          then obhigh.ActualDeliveryQuantity
        else obitem.ActualDeliveryQuantity
      end                              as OriginalDeliveryQuantity,
      obhdr.DeliveryDate               as DeliveryDate,
      obhdr.ActualGoodsMovementDate    as Actualgoodsmovementdate,
      obhdr.BillOfLading               as BillofLading,
      obhdr.DeliveryDocumentBySupplier as Deliverydocumentbysupplier,
      obhdr.PlannedGoodsIssueDate      as plandate,
      obhdr.OverallGoodsMovementStatus as obhdr_status
}
where
       obitem.OutboundDelivery             is not initial
  and  obitem.OutboundDeliveryItem         is not initial
  and(
       obitem.DeliveryDocumentItemCategory = 'TAN'
    or obitem.DeliveryDocumentItemCategory = 'CBXN'
  )
