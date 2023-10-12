.include "hw5_macrolib.s"

.global main

.data
	arrayA: .word 10

main:
	# Выводим сообщение с просьбой ввести кол-во элементов в массиве.
	print_str ("Enter the number of array elements from 1 to 10: ") 
	# Считывем кол-во элементов массива в a0
	read_int_a0	
       
	# Положим переменную на стек
	addi sp, sp, -4
	sw   a0, (sp)
	# Функция на проверку размера массива
	jal check_limits
	# "Почистили" то, что положили
        addi sp sp 4
	# Проверим, что вернула функция
	mv t6 a1
	li a1 1
	beq a0 a1, .correct_main_size		# (a0 == a1) -> .correct_main_size
	print_str("The number is not in the range [1 ; 10]!")
	j .end_main
	
	.correct_main_size:
	# Если попали сюда - проверка прошла, считываем массив
	la   t1 arrayA
	addi sp, sp, -4
	sw   t1, (sp)
	li t1 0
	jal input_array
	lw   a0, (sp)  # Загрузили наш массив
	addi sp sp 4
	# Вызовем функцию разности между двумя соседним элементами
	# Но перед этим положим массив A на стек
	addi sp, sp, -4
	sw  a0, (sp)
	jal slozhenie
	addi sp, sp, 4
	
	print_str("Sum of all elements is: ")
	print_int (t2)
	
	.end_main:
	li a0 0
	li a7 10
	ecall

	
