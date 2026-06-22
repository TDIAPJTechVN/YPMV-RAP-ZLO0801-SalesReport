CLASS zcl_lo08_sales_vir DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LO08_SALES_VIR IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    IF iv_entity NS 'ZC_LO08_SALESRPT'.
      RETURN.
    ENDIF.
*    LOOP AT it_requested_calc_elements ASSIGNING FIELD-SYMBOL(<fs_calc_element>).
*      CASE <fs_calc_element>.
*        WHEN 'ZLONGTEXT'.
*          INSERT `PRODUCTCODE` INTO TABLE et_requested_orig_elements.
*
*        WHEN OTHERS.
*      ENDCASE.
*    ENDLOOP.
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA: lt_original_data TYPE TABLE OF zc_lo08_salesrpt.
    lt_original_data = CORRESPONDING #( it_original_data ).

    SELECT DISTINCT obtp~OutboundDelivery, obtp~YY1_BATCH_DLH
    FROM I_OUTBOUNDDELIVERYTP AS obtp
       INNER JOIN @lt_original_data AS dt ##ITAB_DB_SELECT  ##ITAB_KEY_IN_SELECT
               ON dt~OutboundDelivery = obtp~OutboundDelivery
        ORDER BY obtp~OutboundDelivery
       INTO TABLE @DATA(lt_obtp).

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<lf_data>).
      READ TABLE lt_obtp INTO DATA(ls_tp) WITH KEY OutboundDelivery = <lf_data>-OutboundDelivery BINARY SEARCH.
      IF sy-subrc = 0.
        <lf_data>-ZBatch = ls_tp-yy1_batch_dlh.
      ENDIF.
      CONDENSE: <lf_data>-ZBatch .
    ENDLOOP.
    ct_calculated_data = CORRESPONDING #(  lt_original_data ).
  ENDMETHOD.
ENDCLASS.
