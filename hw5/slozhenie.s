.global slozhenie

.text
slozhenie:
	# Функция вычитания первого из второго числа и запись в массив B
	# Возвращает количество элементов в массиве B
	addi sp sp -4
	sw   ra (sp)
	
	addi a6 sp 4	
	lw  t1 (a6) # берем из стека arrayA


	# Тут сложение всех чисел и проверка на переполнение
	for_loop:
	
		# (a1 == 0) -> цикл закончился, либо, если в массиве A 1 элемент, то идем выводить пустой массив B
		beqz t6, end_slozhenie
		addi t6 t6 -1
	
		lw s0 (t1)	# положили в s0 из массива 1й элемент
		addi t1 t1 4
		
		add   t2, t2, s0    # Сложение a0 и a1 и сохранение результата в t2
		j for_loop
	
end_slozhenie:
	lw ra (sp)    # восстановим текущий ra
	addi sp sp 4  # из стека
	

	
	# Возвращаем s0, s1 к начальному значению
	li s0 0
	ret
       
