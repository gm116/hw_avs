# Variant 9. Fadeev Daniil BPI227

.include "ihw2_macrolib.s"

    .data
eps:
   	.double 0.0005
first_input:
   	.double 0.942
second_input:
   	.double 0.382132
third_input:
   	.double -0.492
   	
	.text
main:
	fld     f0 eps t0   # f0 = epsilon
	
	# Основной кусок кода для первого значения
	#
	#
	print_str("1st value = ")
	fld     f1 first_input t0
	print_double(f1)
	print_str("\n")
        # Самая главная функция, которая считает арктангенс. Вынесена в отдельную библиотеку
        calc_arctan(f1)
       
    	print_str("Value arctan with epsilon 0.05% = ") 
	print_double(fa0)
	print_str("\n")
	
	# Основной кусок кода для второго значения
	#
	#
	print_str("2nd value = ")
	fld     f1 second_input t0
	print_double(f1)
	print_str("\n")
        # Самая главная функция, которая считает арктангенс. Вынесена в отдельную библиотеку
        calc_arctan(f1)
       
    	print_str("Value arctan with epsilon 0.05% = ") 
	print_double(fa0)
	print_str("\n")
	
	# Основной кусок кода для третьего значения
	#
	#
	print_str("3rd value = ")
	fld     f1 third_input t0
	print_double(f1)
	print_str("\n")
        # Самая главная функция, которая считает арктангенс. Вынесена в отдельную библиотеку
        calc_arctan(f1)
       
    	print_str("Value arctan with epsilon 0.05% = ") 
	print_double(fa0)
	print_str("\n")
		
    	exit

