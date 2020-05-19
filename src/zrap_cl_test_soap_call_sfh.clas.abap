CLASS zrap_cl_test_soap_call_sfh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    METHODS get_number_in_words
      IMPORTING iv_number                 TYPE zrap_inven_sfh-quantity
      RETURNING VALUE(rv_number_in_words) TYPE string .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zrap_cl_test_soap_call_sfh IMPLEMENTATION.

  METHOD get_number_in_words.

    TRY.
*        DATA(destination) = cl_soap_destination_provider=>create_by_cloud_destination(
*                              i_name = '<Name of your Cloud Destination>'
*                              i_service_instance_name = '<Service Instance Name>'
*                            ).

        DATA(destination) = cl_soap_destination_provider=>create_by_url( i_url = 'https://www.dataaccess.com/webservicesserver/numberconversion.wso' ).

        DATA(proxy) = NEW zco_number_conversion_soap_t10( destination = destination ).

        DATA(request) = VALUE znumber_to_words_soap_reques10( ).

        request-ubi_num = iv_number.

        proxy->number_to_words(
          EXPORTING
            input = request
          IMPORTING
            output = DATA(response)
        ).

        "handle response
        rv_number_in_words = response-number_to_words_result .


      CATCH cx_soap_destination_error.
        "handle error
        rv_number_in_words = 'soap error'.
      CATCH cx_ai_system_fault.
        "handle error
        rv_number_in_words = 'system error'.
    ENDTRY.

  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    DATA(lv_bonus_in_words) = get_number_in_words( 4655051 ).
    out->write( lv_bonus_in_words ) .
  ENDMETHOD.


ENDCLASS.
