# Фадеев Даниил ИДЗ-3 БПИ227 вариант 25
# P.S. использовал комментарии с семинарского файла, тк они достаточно подробные и с ними все понятнее

.global main
.include "macro-syscalls.m"

.eqv    NAME_SIZE 256		# Размер буфера для имени файла
.eqv    TEXT_SIZE 512		# Размер буфера для текста
.eqv	SIZE_FOR-OUT 512 	# размер для вывода (НЕ ДЛЯ ВВОДА!)
.data
	yes_or_no:	.space 2
	str:		.space TEXT_SIZE	# Строка со словами
	file_name:      .space NAME_SIZE	# Имя читаемого файла
	strbuf:		.space TEXT_SIZE	# Буфер для читаемого текста

.text
main:

    print_str ("Do you want to see results in console?\nType 'Y' or 'N': ")
    str_get(yes_or_no, 2)
    la a0 yes_or_no
    lb s8 (a0)
    li s7 89
    bne s8 s7 jump
    print_str ("\nYou will see results!\n")
    li s7 0
    li s8 1 	# значение true в s8 для вывода инфы
    j jump_with_res
    jump:
    print_str ("\n")
    li s7 0
    li s8 0	# значение false в s8 для вывода инфы
    jump_with_res:
    ###############################################################
    print_str ("Input path to file for reading: ") # Вывод подсказки
    # Ввод имени файла с консоли эмулятора
    str_get(file_name, NAME_SIZE)
    open(file_name, READ_ONLY)
    li		s1 -1		# Проверка на корректное открытие
    beq		a0 s1 er_name	# Ошибка открытия файла
    mv   	s0 a0       	# Сохранение дескриптора файла
    ###############################################################
    # Выделение начального блока памяти для для буфера в куче
    allocate(TEXT_SIZE)		# Результат хранится в a0
    mv 		s3, a0			# Сохранение адреса кучи в регистре
    mv 		s5, a0			# Сохранение изменяемого адреса кучи в регистре
    li		s4, TEXT_SIZE	# Сохранение константы для обработки
    mv		s6, zero		# Установка начальной длины прочитанного текста
    ###############################################################
read_loop:
    # Чтение информации из открытого файла
    read_addr_reg(s0, s5, TEXT_SIZE) # чтение для адреса блока из регистра
    # Проверка на корректное чтение
    beq		a0 s1 er_read	# Ошибка чтения
    mv   	s2 a0       	# Сохранение длины текста
    add 	s6, s6, s2		# Размер текста увеличивается на прочитанную порцию
    # При длине прочитанного текста меньшей, чем размер буфера,
    # необходимо завершить процесс.
    bne		s2 s4 end_loop
    # Иначе расширить буфер и повторить
    allocate(TEXT_SIZE)
    add		s5 s5 s2		# Адрес для чтения смещается на размер порции
    b read_loop				# Обработка следующей порции текста из файла
end_loop:
    # Закрытие файла
    close(s0)
    # Установка нуля в конце прочитанной строки
    mv	t0 s3		# Адрес буфера в куче
    add t0 t0 s6	# Адрес последнего прочитанного символа
    addi t0 t0 1	# Место для нуля
    sb	zero (t0)	# Запись нуля в конец текста

    
    mv a0, s3		# закинул для функции посдчета слов
    la s9 str		# для внесения в строку всех слов
    
    # Подпрограмма в отдельном файле для посдчета количества слов, начинающихся с заглавной буквы
    # В a0 возвращает количество слов в тексте.
    jal count_identifiers
    
    # Вывод количество слов, в прочитанном файле
    beqz s8 no_results1 # ?????????
    print_str ("How much words in source file: ")
    print_int(a0)
    newline
    output_sting(str)
    newline
    no_results1:
    la s9 str # повторно закинул в регистр чтобы в записи в файл нужная строка записалась
    
    # Сохранение прочитанного файла в другом файле
    print_str ("Input path to file for writing: ")
    str_get(file_name, NAME_SIZE) # Ввод имени файла с консоли эмулятора
    open(file_name, WRITE_ONLY)
    li		s1 -1		# Проверка на корректное открытие
    beq		a0 s1 er_name	# Ошибка открытия файла
    mv   	s0 a0       	# Сохранение дескриптора файла
    # Запись информации в открытый файл
    li   a7, 64       		# Системный вызов для записи в файл
    mv   a0, s0 		# Дескриптор файла
    mv   a1, s9  		# Адрес буфера записываемого текста
    mv   a2, s6    		# Размер записываемой порции из регистра
    ecall             		# Запись в файл

    # Вывод числа байт, в финальном файле
    beqz s8 no_results2
    print_str ("There is bytes in the final file only with words: ")
    print_int(s6)
    newline
    # Использование strlen для подсчета числа байт в исходнике
    print_str ("strlrn for the source file: ")
    mv 	a0, s3
    jal strlen
    print_int(a0)
    newline
no_results2:       
    exit
er_name:
    # Сообщение об ошибочном имени файла
    print_str ("Incorrect file name\n")
    exit
er_read:
    # Сообщение об ошибочном чтении
    print_str ("Incorrect read operation\n")
    exit
    
    
    
   
  

