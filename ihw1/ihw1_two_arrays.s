# Вариант 33

.data
	arrayA: 	.word 10
	

	input_msg:  	.asciz "Enter the number of array elements from 1 to 10: "
    	size_exception: .asciz "The number is not in the range [1 ; 10]!"
    	prompt:  	.asciz "Enter your number: "
    	arrayB_msg: 	.asciz "Array B is: "
    	space: 		.asciz " "
    	
	arrayB: 	.word 10

.text
	# Выводим сообщение с просьбой ввести кол-во элементов в массиве.
	la a0, input_msg
	li a7, 4
	ecall
       
        li a7 5
        ecall			# считали кол-во элементов массива
        
        mv t0 a0		# помещаем кол-во элементов
        
       
	# Положим переменную на стек
	addi sp, sp, -4
	sw   a0, (sp)
	# Функция на проверку размера массива
	jal check_limits
	
	# "Почистили" то, что положили
        addi sp sp 4
        
	# Проверим, что вернула функция
	li a1 1
	beq a0 a1, .correct_main_size		# (a0 == a1) -> .correct_main_size
	
	# Если попали сюда - значит размер не удовлетворяет нужному
	la a0, size_exception
	li a7 4
	ecall
	j .end_main # Завершаем работу программы
	
	.correct_main_size:
	# Если попали сюда - проверка прошла, считываем массив
	jal input_array
	
	# Вызовем функцию разности между двумя соседним элементами
	# Но перед этим положим массив A на стек
	addi sp, sp, -4
	sw  a0, (sp)
	jal vychitanie
	addi sp, sp, 4
	
	# Вызовем функцию вывода результата (элементов массива B)
	# Но перед этим положим количетсво элементов массива B на стек
	addi sp, sp, -4
	sw  a0, (sp)
	jal output
	addi sp, sp, 4
	
	.end_main:
	li a0 0
	li a7 10
	ecall

.text
output:
	# Функция вывода массива B с результатом
	addi sp, sp, -4
	sw   ra, (sp)
	
	addi a6, sp, 4	
	lw t1, (a6) # берем из стека кол-во элементов в массиве B

	la t2 arrayB	# тут сам массив B
	
	# Инфо, что выводится массив B
	la a0 arrayB_msg
	li a7 4
	ecall
	
	out_loop:
		bnez t1, out	# (t1 != 0) -> выводим элемент массива
		
	    	# Если условие не выполняется, то идем сюда
	    	lw   ra (sp)    # восстановим текущий ra
		addi sp sp 4  	# из стека
		
		# Восстанавлиаем значения t1, t2
	    	li   t1 0		
		li   t2 0
		
		ret
	
		out:  
		addi t1 t1 -1	# сдвигаем счетчик
	        lw   a0 (t2)	# помещаяем в a0 элемент
	        # Вывод элемента
	        li   a7 1
		ecall
		# Вывод пробела между элементами
		la   a0 space
		li   a7 4
		ecall
		
	        addi t2 t2 4
		j out_loop
	
.text
vychitanie:
	# Функция вычитания первого из второго числа и запись в массив B
	# Возвращает количество элементов в массиве B
	addi sp sp -4
	sw   ra (sp)
	
	addi a6 sp 4	
	lw  t1 (a6) # берем из стека arrayA

	la  t2 arrayB
	
	li  a0 1
	sub a1 t0 a0 	# проверяем, сколько элементов должно быть в массиве B

	# Тут и будт происходить само вычитание и запись в массив B.
	for_loop:
	
		# (a1 == 0) -> цикл закончился, либо, если в массиве A 1 элемент, то идем выводить пустой массив B
		beqz a1, end_vychitanie
		addi a1 a1 -1
	
		lw s0 (t1)	# положили в s0 из массива 1й элемент
		addi t1 t1 4
		lw s1 (t1)	# положили в s1 из массива 2й элемент
	
		sub t3 s0 s1
		sw t3 (t2)
		addi t2 t2 4
		j for_loop
	
	
end_vychitanie:
	lw ra (sp)    # восстановим текущий ra
	addi sp sp 4  # из стека
	
	# Возвращаем в a0 количество элементов в arrayB
	sub a0 t0 a0
	
	# Возвращаем s0, s1 к начальному значению
	li s0 0
	li s1 0
	ret
       
.text
check_limits:
	# Функция проверяет, входит ли переданное число в границы от 1 до 10 включительно
	# Если удовлетворяет условию, возвращает 1(true), иначе 0(false). Значение кладется в a0
	addi sp, sp, -4
	sw   ra, (sp)
	
	# Считаем данные со стека
	addi a0, sp, 4
	lw   a1, (a0)  # Загрузили наше число
	li   a0, 1 # bool res = true
	
	li  a2, 1
	blt a1, a2, .incorrect_check_size 	# (a1 < 1) -> .incorrect_check_size 
	
	li  a2, 11
	bge a1, a2, .incorrect_check_size	# (a1 >= 11) -> .incorrect_check_size 
	
	j .end_check
	
	.incorrect_check_size:
	li   a0, 0	# a0 = false
	
	.end_check:
	lw   ra (sp)    # восстановим текущий ra
	addi sp sp 4  # из стека
	ret
 	
 	
.text
input_array:
	# Функция возвращает заполненный массив A
	addi sp, sp, -4
	sw   ra, (sp)
	
	la   t1 arrayA
	# Ввод данных в массив на основании количества, переданного в качестве аргумента(передаем через a0)
	li   t2 -1
	loop:
		addi t2 t2 1		# Увеличение
		blt t2 t0 input      	# Сравнение счётчика и границы и переход
	    
	    	la a0 arrayA
		li t2 0
		
		lw ra (sp)    # восстановим текущий ra
		addi sp sp 4  # из стека
		ret
	
		input:  
			# Подсказка для пользователя о вводе числа
			la a0 prompt
			li a7 4
	        	ecall
	        	
	       		li a7 5
	        	ecall

	        	sw a0 (t1)
	        	addi t1 t1 4
			j loop
