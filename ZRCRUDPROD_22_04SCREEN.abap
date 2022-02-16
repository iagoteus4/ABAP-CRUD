SELECTION-SCREEN BEGIN OF BLOCK bloco1 WITH FRAME TITLE TEXT-001.
PARAMETERS: create RADIOBUTTON GROUP crd,
            read   RADIOBUTTON GROUP crd,
            update RADIOBUTTON GROUP crd,
            delete RADIOBUTTON GROUP crd.
SELECTION-SCREEN END OF BLOCK bloco1.

SELECTION-SCREEN BEGIN OF BLOCK bloco2 WITH FRAME TITLE TEXT-002.
PARAMETERS: p_prod  TYPE zprodutos_22_07-produto,
            p_desc  TYPE zprodutos_22_07-desc_produto,
            p_preco TYPE zprodutos_22_07-preco,
            p_moeda TYPE zprodutos_22_07-moedas.
SELECTION-SCREEN END OF BLOCK bloco2.
