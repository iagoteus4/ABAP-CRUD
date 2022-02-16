FORM f_verifica_crud.
  CASE 'X'.

    WHEN create.
      IF  p_prod  IS NOT INITIAL AND
          p_desc  IS NOT INITIAL AND
          p_preco IS NOT INITIAL AND
          p_moeda IS NOT INITIAL.
        PERFORM f_insere_dados.
      ELSE.
        MESSAGE 'Erro ao cadastrar o produto ( Preencha todos os campos )' TYPE 'S' DISPLAY LIKE 'E'.
      ENDIF.

    WHEN read.
      IF p_prod IS NOT INITIAL.
        PERFORM f_seleciona_dados_single.
      ELSE.
        PERFORM f_seleciona_dados.
      ENDIF.
    WHEN update.
      IF p_prod  IS NOT INITIAL AND
         p_desc  IS NOT INITIAL AND
         p_preco IS NOT INITIAL AND
         p_moeda IS NOT INITIAL.
        PERFORM f_update_dados.
      ELSE.
        MESSAGE 'Erro ao editar o produto ( Preencha todos os campos )' TYPE 'S' DISPLAY LIKE 'E'.
      ENDIF.
    WHEN delete.
      IF p_prod IS NOT INITIAL.
        PERFORM f_deleta_dados.
      ELSE.
        MESSAGE 'Erro ao deletar o produto ( Preencha o campo CÓDIGO DO PRODUTO )' TYPE 'S' DISPLAY LIKE 'E'.
      ENDIF.
  ENDCASE.
ENDFORM.


FORM f_insere_dados.
  DATA lv_erro.
  ls_produto-produto = p_prod.
  ls_produto-desc_produto = p_desc.
  ls_produto-preco = p_preco.
  ls_produto-moeda = p_moeda.
  CALL FUNCTION 'ZFM_INSERT_PRODUTO_22_04'
  EXPORTING
    is_produto = ls_produto
  IMPORTING
    ev_erro = lv_erro.
*  INSERT zprodutos_22_04 FROM ls_produto.
  FREE: ls_produto.

  IF lv_erro <> ''.
    MESSAGE 'Erro ao inserir o produto' TYPE 'S' DISPLAY LIKE 'E'.
    ROLLBACK WORK.
    EXIT.
  ELSE.
    MESSAGE 'Produto cadastrado com sucesso !' TYPE 'S' DISPLAY LIKE 'I'.
    COMMIT WORK.
  ENDIF.
ENDFORM.

FORM f_update_dados.

  ls_produto-produto = p_prod.
  ls_produto-desc_produto = p_desc.
  ls_produto-preco = p_preco.
  ls_produto-moeda = p_moeda.

  UPDATE zprodutos_22_04 FROM ls_produto.
  FREE ls_produto.
  IF sy-subrc <> 0.
    MESSAGE 'Erro ao modificar os dados do produto' TYPE 'S' DISPLAY LIKE 'E'.
    ROLLBACK WORK.
    EXIT.
  ELSE.
    MESSAGE 'Produto editado com sucesso !' TYPE 'S' DISPLAY LIKE 'I'.
    COMMIT WORK.
  ENDIF.
ENDFORM.

FORM f_deleta_dados.
  DELETE FROM zprodutos_22_04 WHERE produto = p_prod.
  IF sy-subrc <> 0.
    MESSAGE 'Erro ao deletar o produto' TYPE 'S' DISPLAY LIKE 'E'.
    ROLLBACK WORK.
    EXIT.
  ELSE.
    MESSAGE 'Produto deletado com sucesso !' TYPE 'S' DISPLAY LIKE 'I'.
    COMMIT WORK.
  ENDIF.
ENDFORM.

FORM f_seleciona_dados_single.
  ls_produto-produto = p_prod.
  SELECT produto
         desc_produto
         preco
         moeda
    FROM zprodutos_22_04
    INTO CORRESPONDING FIELDS OF TABLE lt_produto
    WHERE produto = ls_produto-produto.
  IF sy-subrc IS NOT INITIAL OR lt_produto IS INITIAL.
    MESSAGE 'Nenhum produto foi encontrado com esse código de produto' TYPE 'S' DISPLAY LIKE 'E'.
    ROLLBACK WORK.
  ELSE.
    COMMIT WORK.
    EXIT.
  ENDIF.
  PERFORM f_exibe_dados.
ENDFORM.

FORM f_seleciona_dados.
  SELECT produto
         desc_produto
         preco
         moeda
  FROM zprodutos_22_04
  INTO CORRESPONDING FIELDS OF TABLE lt_produto.
  IF sy-subrc IS NOT INITIAL OR lt_produto IS INITIAL.
    MESSAGE 'Nenhum produto foi encontrado' TYPE 'S' DISPLAY LIKE 'E'.
    ROLLBACK WORK.
    EXIT.
  ELSE.
    COMMIT WORK.
  ENDIF.
  PERFORM f_exibe_dados.
ENDFORM.

FORM f_exibe_dados.
  TRY.
      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = lo_alv
        CHANGING
          t_table      = lt_produto.

      lo_functions = lo_alv->get_functions( ).
      lo_functions->set_all( 'X' ).


      lo_alv->display( ).
    CATCH cx_salv_msg INTO DATA(lx_msg).
      lx_msg->get_message( ).
  ENDTRY.
ENDFORM.
