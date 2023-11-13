#===============================================================================
# Библиотека макроопределений для системных вызовов
#===============================================================================

# Печать перевода строки
.macro newline
   print_char('\n')
.end_macro


.macro output_sting(%x)
   la      a0 %x
   li      a7 4
   ecall
.end_macro


.macro strcpy
    .eqv     BUF_SIZE 100
    .data
buf:    .space BUF_SIZE     # Буфер для чтения данных
buf2:    .space BUF_SIZE     # Буфер для чтения данных
short_test_str: .asciz "Hi! YESSS"     # Короткая тестовая строка
long_test_str:  .asciz "AAAdasdasdSDADASD" # Длинная тестовая строка

la      a0 short_test_str
    li      a1 BUF_SIZE
        la      a2 buf2
loop:
    lb      t1 (a0)   # Загрузка символа для сравнения
    beqz    t1 end
    sb 	    t1 (a2)	
    addi    a0, a0, 1         # Увеличение адреса целевой строки
    addi    a2, a2, 1         # Увеличение адреса копированной строки
    bge     t0 a2 end       # Выход, по превышению размера буфера
    b       loop
end:
    ret
.end_macro



# Завершение программы
.macro exit
    li a7, 10
    ecall
.end_macro


.macro print_char(%x)
   li a7, 11
   li a0, %x
   ecall
.end_macro
#-------------------------------------------------------------------------------
