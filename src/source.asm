; ---------------------------------------------------------
; Title:  Assignment2_Combined.asm
; Desc:  Implements Q2, Q3, Q4 in one file using Irvine32.
; ---------------------------------------------------------


ExitProcess PROTO, dwExitCode:DWORD

include Irvine32.inc
includelib Irvine32.lib

.data
; ---------------------------------------------------------
; Data Section
; ---------------------------------------------------------

; ----- Q2: 4x4 matrix for filling sequential values -----
matrix  DWORD 4 DUP(4 DUP(?))    ; uninitialized 4x4 = 16 DWORDs

msgMatrixStart   BYTE "----- 4x4 Matrix -----", 0

; ----- Q3: arr1, arr2 for copy -----
arr1    DWORD 10, 21, 30, 41, 50, 61, 70, 81, 90, 101  ; 10 elements
arr2    DWORD 10 DUP(?)                               ; destination array

msgArr1  BYTE "----- Original array (arr1) -----", 0
msgArr2  BYTE "----- Copied array (arr2)   -----", 0

; ----- Q4: Reverse only even elements into arr3 -----
arr3    DWORD 10 DUP(?)  ; stores reversed even numbers from arr1

msgArr3  BYTE "----- Reversed even array (arr3) -----", 0

.code
; ---------------------------------------------------------
; Q2. fillMatrix PROC
; Fills the 4x4 matrix with sequential values 1..16.
; ---------------------------------------------------------
fillMatrix PROC
    push ebp
    mov  ebp, esp

    mov  ecx, 16               ; total 16 DWORDs
    mov  edi, OFFSET matrix
    mov  eax, 1                ; start from 1

fillLoop:
    mov  [edi], eax
    add  edi, 4                ; next DWORD
    inc  eax
    loop fillLoop

    pop  ebp
    ret
fillMatrix ENDP


; ---------------------------------------------------------
; Q2. printMatrix PROC
; Prints the 4x4 matrix row by row.
; ---------------------------------------------------------
printMatrix PROC
    push ebp
    mov  ebp, esp

    ; Print header
    mov  edx, OFFSET msgMatrixStart
    call WriteString
    call Crlf

    mov  ecx, 16               ; 16 DWORD elements
    mov  esi, OFFSET matrix

printLoop:
    mov  eax, [esi]
    call WriteDec
    call Crlf
    add  esi, 4
    loop printLoop

    pop  ebp
    ret
printMatrix ENDP


; ---------------------------------------------------------
; Q3. copyArr PROC
; Copies arr1 to arr2 using indirect addressing.
; ---------------------------------------------------------
copyArr PROC
    push ebp
    mov  ebp, esp

    mov  ecx, LENGTHOF arr1
    mov  esi, OFFSET arr1
    mov  edi, OFFSET arr2

copyLoop:
    mov  eax, [esi]
    mov  [edi], eax
    add  esi, 4
    add  edi, 4
    loop copyLoop

    pop  ebp
    ret
copyArr ENDP


; ---------------------------------------------------------
; Q3. printArr1 PROC
; Prints arr1 elements.
; ---------------------------------------------------------
printArr1 PROC
    push ebp
    mov  ebp, esp

    mov  edx, OFFSET msgArr1
    call WriteString
    call Crlf

    mov  ecx, LENGTHOF arr1
    mov  esi, OFFSET arr1

printArr1Loop:
    mov  eax, [esi]
    call WriteDec
    call Crlf
    add  esi, 4
    loop printArr1Loop

    pop  ebp
    ret
printArr1 ENDP


; ---------------------------------------------------------
; Q3. printArr2 PROC
; Prints arr2 elements.
; ---------------------------------------------------------
printArr2 PROC
    push ebp
    mov  ebp, esp

    mov  edx, OFFSET msgArr2
    call WriteString
    call Crlf

    mov  ecx, LENGTHOF arr2
    mov  esi, OFFSET arr2

printArr2Loop:
    mov  eax, [esi]
    call WriteDec
    call Crlf
    add  esi, 4
    loop printArr2Loop

    pop  ebp
    ret
printArr2 ENDP


; ---------------------------------------------------------
; Q4. reverseEven PROC
; 1) Scans arr1 to find even numbers
; 2) Pushes each even number on the stack
; 3) Pops them into arr3 (which reverses their order)
; ---------------------------------------------------------
reverseEven PROC
    push ebp
    mov  ebp, esp

    ; Step 1: Count # evens in arr1
    mov  ecx, LENGTHOF arr1
    mov  esi, OFFSET arr1
    xor  edx, edx             ; edx = 0 for counting evens

countLoop:
    mov  eax, [esi]
    test eax, 1               ; if LSB=1, it's odd
    jnz  skipCount
    inc  edx                  ; found even
skipCount:
    add  esi, 4
    loop countLoop

    ; Step 2: Push each even number
    mov  ecx, LENGTHOF arr1
    mov  esi, OFFSET arr1

pushLoop:
    mov  eax, [esi]
    test eax, 1
    jnz  skipPush
    push eax
skipPush:
    add  esi, 4
    loop pushLoop

    ; Step 3: Pop them into arr3 (reverse order)
    mov  ecx, edx             ; how many evens we pushed
    mov  edi, OFFSET arr3

popLoop:
    pop  eax
    mov  [edi], eax
    add  edi, 4
    loop popLoop

    pop  ebp
    ret
reverseEven ENDP


; ---------------------------------------------------------
; Q4. printArr3 PROC
; Prints arr3 elements (10 total, but only some may be valid).
; ---------------------------------------------------------
printArr3 PROC
    push ebp
    mov  ebp, esp

    mov  edx, OFFSET msgArr3
    call WriteString
    call Crlf

    mov  ecx, LENGTHOF arr3
    mov  esi, OFFSET arr3

printArr3Loop:
    mov  eax, [esi]
    call WriteDec
    call Crlf
    add  esi, 4
    loop printArr3Loop

    pop  ebp
    ret
printArr3 ENDP


; ---------------------------------------------------------
; main PROC
; Calls each of the above procedures in order:
;   1) Fill & print 4x4 matrix (Q2)
;   2) Copy arr1->arr2 & print both (Q3)
;   3) Reverse only even elements of arr1 into arr3 & print (Q4)
; ---------------------------------------------------------
main PROC
    ; ----- Q2 -----
    call fillMatrix
    call printMatrix

    ; ----- Q3 -----
    call copyArr
    call printArr1
    call printArr2

    ; ----- Q4 -----
    call reverseEven
    call printArr3

    call Crlf
    exit
main ENDP

END main
