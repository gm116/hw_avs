.global input_array
.include "hw5_macrolib.s"

.text
input_array:
	# Функция возвращает заполненный массив A
	addi sp, sp, -4
	sw   ra, (sp)
	
	addi t1, sp, 4
	lw   t1, (t1)  # Загрузили наш массив
	
	# Ввод данных в массив на основании количества, переданного в качестве аргумента(передаем через t6)

	loop:
		addi t2 t2 1		# Увеличение
		ble t2 t6 input      	# Сравнение счётчика и границы и переход
	    
		li t2 0
		
		lw ra (sp)    # восстановим текущий ra
		addi sp sp 4  # из стека
		ret
	
		input:  
			# Подсказка для пользователя о вводе числа
			print_str ("Enter your number: ")
			read_int_a0
			
	        	sw a0 (t1)
	        	addi t1 t1 4
			j loop
