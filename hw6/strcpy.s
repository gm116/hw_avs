.include "macro-syscalls.m"

.eqv     BUF_SIZE 100
    .data
buf:    .space BUF_SIZE     # Буфер для чтения данных
buf2:    .space BUF_SIZE     # Буфер для чтения данных
short_test_str: .asciz "Hi! YESSS"     # Короткая тестовая строка
long_test_str:  .asciz "AAAdasdasdSDADASD" # Длинная тестовая строка

    .text
    strcopy:

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


.globl main
main:
    # Ввод строки в буфер
    la      a0 buf
    li      a1 BUF_SIZE
    li      a7 8
    ecall
   
    # Копирование для вводимой строки
    la      a0 buf
    la      a2 buf2
    li      a1 BUF_SIZE
    jal strcopy

    # вывод строки
    output_sting(buf2)


    # Вычисление длины для короткой	строки
    la      a0 short_test_str
    li      a1 BUF_SIZE
        la      a2 buf2
    jal     strcopy
   # вывод строки
       output_sting(short_test_str)
       newline
       output_sting(buf2)
       newline

    # Вычисление длины для длинной	строки
    la      a0 long_test_str
    li      a1 BUF_SIZE
        la      a2 buf2
    jal     strcopy
    # вывод строки
      	output_sting(long_test_str)
	newline
   	output_sting(buf2)
	newline

    # Завершение программы
	exit
    
    

