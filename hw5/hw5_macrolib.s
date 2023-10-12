.macro print_str (%x)
.data
	str: .asciz %x
.text
   	li a7, 4
   	la a0, str
   	ecall
.end_macro



.macro read_int(%x)
   	li a7, 5
 	ecall
	mv %x, a0
.end_macro
   


# Ввод целого числа с консоли в регистр a0
.macro read_int_a0
   	li a7, 5
   	ecall
.end_macro

# Печать содержимого регистра как целого
.macro print_int (%x)
	li a7, 1
	mv a0, %x
	ecall
.end_macro
