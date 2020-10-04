format PE console
;------------------------------------------------------------------------------------------------------------------
;Кочик Дмитрий Алексеевич
;БПИ199
;Вариант 11
;------------------------------------------------------------------------------------------------------------------

include 'win32a.inc'
entry start

section '.data' data readable writable
        strInputArrNum db 'Please, enter a positive integer number of elements but less than 200 ', 0
        strIncorNum    db 'Number of elements should be positive and less than 200, but you entered  %d', 0
        strInputInfo   db 'Now you need to input elements one by one', 10, 0
        strNewArr      db 'New array B:', 10, 0
        strInputEl     db 'Value of [%d] ', 0
        strScanInt     db '%d', 0
        strOutput      db '[%d] = %d', 10, 0

        arr_size dd 0
        val1     dd ?
        val2     dd ?
        val3     dd ?
        val4     dd 0
        val5     dd 0
        i        dd ?
        i2       dd 0
        arr      rd 200

section '.code' code readable executable

        start:
                call getArray         ; Заполняем массив.
                call printArray       ; Выводим массив.
        finish:
                call [getch]
                push 0
                call [ExitProcess]
;------------------------------------------------------------------------------------------------------------------
        printArray:
                mov [val2], esp       ; Запоминаем начальное положение функции.

                push strNewArr
                call [printf]         ; Console: New array B:
                xor ecx, ecx          ; Обнуляем регистр.
                xor eax, eax
                mov ebx, arr          ; Запоминаем ссылку на крайний эл-т
                mov [val3], 0         ; Счетчик положительных чисел

        outputtingStart:
                mov [val1], ebx
                cmp ecx, [arr_size]   ; Проверяем, не вышли ли мы за границу массива.
                jge endOutp           ; Если вышли - завершаем заполнение массива.

                mov [i], ecx

                mov eax, [ebx]
                cmp [val4], eax
                jge allOk             ; Если эл-т отрицателен или 0, просто выводим его.

                cmp [val3], 0         ; Если положительный эл-т уже выводился, просто выводим его.
                jne allOk
                inc [val3]            ; Если это первый положительный эл-т, увеличиваем счетчик и не выводим его.
                jmp allNotOk
        allOk:
                mov eax, [i]
                sub eax, [val3]       ; Считаем индекс масссива В в зависимости от того был ли уже первый положительный или нет.
                pushd [ebx]
                push eax
                push strOutput
                call[printf]          ; Console: [{индекс в массиве В}] = {эл-т массива В}

        allNotOk:
                mov ecx, [i]
                inc ecx               ; Увеличиваем счетчик эл-в.
                mov ebx, [val1]
                add ebx, 4            ; Смещаемся на 1 эл-т вперед в исходном массиве.
                jmp outputtingStart   ; Возвращаемся к началу цикла.

        endOutp:
                mov esp, [val2]       ; Возвращаем значение позиции стека во время вызова.
                ret
;------------------------------------------------------------------------------------------------------------------
        getArray:
                mov [val2], esp       ; Запоминаем начальное положение функции.
                push strInputArrNum
                call [printf]         ; Console: Please, enter a positive number of elements but less than 20
                add esp, 4

                push arr_size
                push strScanInt
                call [scanf]          ; Считываем введенное число.
                add esp, 8

                mov eax, [arr_size]   ; Сохраняем введенный.
                cmp eax, 0            ; Проверяем, больше ли чем 0 размер массива.
                jbe failSize          ; Если размер отрицателен, завершаем выполнение, иначе,
                                      ; проверяем, не превышает ли он допустимый размер массива.
                cmp eax, 200
                jb getValBegin        ; Если введенный размер принадлежит отрезку [1;199], заполняем его.

        failSize:
                push [arr_size]
                push strIncorNum
                call [printf]         ; Console: Number of elements should be positive and less than 200, but you entered  {введенный размер}
                call finish

        getValBegin:
                push strInputInfo
                call [printf]
                ;add esp, 4
                xor ecx, ecx          ; Обнуляем регистр
                mov ebx, arr          ; Запоминаем ссылку на крайний эл-т
        getVal:
                mov [val1], ebx
                cmp ecx, [arr_size]   ; Проверяем, не вышли ли мы за границу массива.
                jge endGetArray       ; Если вышли - завершаем заполнение массива.

                mov [i], ecx
                push ecx
                push strInputEl
                call [printf]         ; Cosnole: Value of [{текущий эл-т массива}]
                add esp, 8

                push ebx
                push strScanInt
                call [scanf]          ; Считываем натуральное число.
                add esp, 8

                mov ecx, [i]
                inc ecx               ; Увеличиваем индекс на 1.
                mov ebx, [val1]
                add ebx, 4
                jmp getVal

        endGetArray:
                mov esp, [val2]       ; Возвращаем значение позиции стека во время вызова.
                ret

section '.idata' import data readable

    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'