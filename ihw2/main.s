# Variant 9. Fadeev Daniil BPI227

.include "ihw2_macrolib.s"

    .data
eps:
   	.double 0.0005
   	
	.text
main:
	fld     f0 eps t0   # f0 = epsilon
	
	print_str("Input x for arctan: ") 
        read_double(f1)
        # Самая главная функция, которая считает арктангенс. Вынесена в отдельную библиотеку
        calc_arctan(f1)
       
    	print_str("Value arctan with epsilon 0.05% = ") 
	print_double(fa0)
		
    	exit

