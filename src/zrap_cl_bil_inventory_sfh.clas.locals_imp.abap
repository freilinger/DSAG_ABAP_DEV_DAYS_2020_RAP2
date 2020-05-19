CLASS lhc_inventory DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      calculate_semantic_key FOR DETERMINATION Inventory~CalculateSemanticKey
        IMPORTING
          it_keys FOR Inventory.



    METHODS:
      fill_quantity_with_words FOR DETERMINATION Inventory~fillQuantityInWords
        IMPORTING
          it_keys FOR Inventory.
ENDCLASS.

CLASS lhc_inventory IMPLEMENTATION.
  METHOD calculate_semantic_key.

    " Determination implementation goes here
    SELECT FROM zrap_inven_sfh
      FIELDS MAX( inventory_id ) INTO @DATA(lv_max_inventory_id).

    LOOP AT it_keys INTO DATA(ls_key).
      lv_max_inventory_id = lv_max_inventory_id + 1.

      MODIFY ENTITIES OF zrap_i_inventory_sfh IN LOCAL MODE
        ENTITY Inventory
          UPDATE SET FIELDS WITH VALUE #( ( Uuid     = ls_key-Uuid
                                            InventoryId = lv_max_inventory_id ) )
          REPORTED DATA(ls_reported).

      APPEND LINES OF ls_reported-inventory TO reported-inventory.
    ENDLOOP.


  ENDMETHOD.



  METHOD fill_quantity_with_words.

    DATA lt_inventory_update        TYPE TABLE FOR UPDATE zrap_i_inventory_sfh.
    DATA ls_inventory_update        LIKE LINE OF lt_inventory_update.

    DATA ls_inventory_failed        TYPE RESPONSE FOR FAILED EARLY zrap_i_inventory_sfh.
    DATA ls_inventory_reported      TYPE RESPONSE FOR REPORTED EARLY zrap_i_inventory_sfh.

    DATA(result) = NEW zrap_cl_test_soap_call_sfh(  ).

    " Read relevant inventory instance data
    READ ENTITIES OF zrap_i_inventory_sfh IN LOCAL MODE
    ENTITY Inventory
     FIELDS ( Quantity )
     WITH CORRESPONDING #(  it_keys )
    RESULT DATA(lt_inventory).

    LOOP AT lt_inventory INTO DATA(ls_inventory).
      ls_inventory_update-Uuid = ls_inventory-%key-Uuid.
      ls_inventory_update-QuantityInWords = result->get_number_in_words( ls_inventory-Quantity ) .
      ls_inventory_update-%control-QuantityInWords = if_abap_behv=>mk-on.
      APPEND ls_inventory_update TO lt_inventory_update.

    ENDLOOP.

    MODIFY ENTITIES OF zrap_i_inventory_sfh
           ENTITY Inventory UPDATE FROM lt_inventory_update
           MAPPED DATA(ls_inventory_mapped)
           FAILED ls_inventory_failed
           REPORTED ls_inventory_reported.
  ENDMETHOD.



ENDCLASS.
