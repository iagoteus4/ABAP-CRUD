TABLES: zprodutos_22_04.

DATA: ls_produto LIKE zprodutos_22_04.

DATA: lt_produto TYPE TABLE OF zprodutos_22_04.

DATA: lo_alv       TYPE REF TO cl_salv_table,
      lo_functions TYPE REF TO cl_salv_functions.
