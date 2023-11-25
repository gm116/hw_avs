
.global count_identifiers

.text
count_identifiers:
     # Инициализация переменных
  li s10, 0       # s10 будет использоваться для подсчета количества идентификаторов
  li t0, 0        # t0 будет использоваться для подсчета количества слов
  li t1, 0        # t1 будет использоваться для хранения текущего символа
  
  
  # Проверка, является ли символ буквой или цифрой (или началом нового идентификатора)
  # ASCII-код буквы 'a' - 'z' и 'A' - 'Z': 65-90, 97-122
  # ASCII-код цифры '0' - '9': 48-57
  li t2, 65       # ASCII-код буквы 'A'
  li t3, 90       # ASCII-код буквы 'Z'
  li t4, 97       # ASCII-код буквы 'a'
  li t5, 122      # ASCII-код буквы 'z'
  li t6, 48       # ASCII-код цифры '0'
  li s11, 57       # ASCII-код цифры '9'
  
  li s6 0
count_loop:
  # Загрузка текущего символа
  lb t1 (a0)

  # Проверка на конец строки
  beqz t1 end_count_loop

 
  blt t1 t6 not_identifier
  ble t1 s11 digit # digit
  blt t1 t2 not_identifier
  ble t1 t3 identifier_continue	# upper
  blt t1 t4 not_identifier
  ble t1 t5 identifier_continue # lower
  
  end_count_loop:
  mv a0 t0
  ret
  
  digit:
  bnez s10 identifier_continue
  addi a0, a0, 1
  j count_loop

  not_identifier:
  # Если символ не является частью идентификатора, обнуляем счетчик
  addi a0, a0, 1
  beqz s10 count_loop
  li t1 32
  sb t1 (s9)
  addi s9 s9 1
  
  add s6 s6 s10 # сколько байт во всех словах будет
  li s10, 0
  addi t0, t0, 1
  
  j count_loop

  identifier_continue:
  # Увеличение счетчика длины идентификатора
  addi s10, s10, 1
  
  sb t1 (s9)
  addi s9 s9 1
  # Переход к следующему символу
  addi a0, a0, 1
  j count_loop
  