@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'LO08: I - Get OB'
define view entity ZI_LO08_OBITM_higher
  as select from    I_OutboundDeliveryItem as obitem
{
  key obitem.OutboundDelivery,
  key obitem.HigherLvlItmOfBatSpltItm,
      obitem.DeliveryQuantityUnit      as DeliveryQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
      sum( obitem.ActualDeliveryQuantity )    as ActualDeliveryQuantity
}
group by OutboundDelivery,
        HigherLvlItmOfBatSpltItm,
        DeliveryQuantityUnit
