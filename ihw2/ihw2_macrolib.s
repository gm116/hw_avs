.macro print_str (%x)
.data
	str: .asciz %x
.text
   	li a7, 4
   	la a0, str
   	ecall
.end_macro

# Завершение программы
.macro exit
    li a7, 10
    ecall
.end_macro

# считываем double
.macro read_double(%x)
        li      a7 7
        ecall
        fmv.d   %x fa0 	# ввели в %x x = double
.end_macro

# Ф-я принимает значение и считает арктангенс
.macro calc_arctan(%x)
 	fmv.d	f28 %x 		# запоминаем term
	fmul.d  f2 %x %x  	# записываем в память x^2 который нужен для степенного ряда
	li      t0 1
   	fcvt.d.w        f3 t0                # тут будет знак
   	fcvt.d.w        f4 t0                # тут знаменатель
	li      	t0 2
   	fcvt.d.w        f5 t0                # тут двойка для прибавления к знаменателю, тк это эффективнее, чем счиатать каждый раз степень
   	
   	# ниже просто нули в регистры, для подсчетов
   	li      	t0 0
   	fcvt.d.w        f7 t0
   	fcvt.d.w        fs0 t0
   	
   	
loop:
	fmul.d f6 f3 f28 	# знак * term
	fadd.d f7 f7 f6 	# записываем в результат
	fadd.d f4 f4 f5 	# прибавляем 2 к знаменателю 
	fsub.d f3 fs0 f3 	# меням знак на противоположный
	fmul.d %x %x f2		# домножаем числитель
	fdiv.d f28 %x f4	# делим
	fabs.d f29 f28		# нужно взять модуль, тк танген может быть отрицательный
    flt.d   t0 f29 f0   	# next summand < eps
    beqz    t0 loop
    fmv.d   fa0 f7 		# возвращаем в регистре fa0
    
.end_macro

# Печать содержимого регистра как double
.macro print_double(%x)
    li      a7, 3         # output a double
    fmv.d   fa0, %x
    ecall
.end_macro
