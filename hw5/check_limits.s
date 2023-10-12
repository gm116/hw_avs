.global check_limits

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
