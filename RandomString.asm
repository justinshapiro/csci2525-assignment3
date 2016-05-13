; Programming Assignmnet #3 for CSCI 2525 - Assembly Language & Computer Organization
; Written by Justin Shapiro


TITLE RandomString.asm
; View in Notepad++ to see the intended formatting

INCLUDE Irvine32.inc	; Needed for the following procedures:
						;	- Randomize 
						;	- RandomRange
						; 	- WriteChar
						; 	- Crlf
						;	- SetTextColor
						; 	- WriteString
						; 	- ReadInt
						; 	- DumpRegs
						;   - WaitMsg

.data
	L = 30											; constant for length of string
	prompt1  BYTE "Enter an integer value: ", 0		; used in conjunction with WriteString to prompt user to perform action when needed
	strArray BYTE L DUP(0)							; array that holds the string (L=30 elements all initialized to 0)
	strPtr   DWORD OFFSET strArray					; pointer to the string array as requested

.code


;=======================================================================;
;--------------------------- MAIN PROCEDURE ----------------------------;
; Function: drives the program, calls UserInt and randStr and contains  ;
;			nested loops to display requested amount of random strings  ;
;			on the terminal window										;
; Requires: nothing														;
; Recieves: nothing														;
; Returns:  nothing														;
; Postcondition: terminal window is filled with a user-defined amount   ;
;				 of strings, each of random capital letters and colors  ;
;=======================================================================;
main PROC

	call Randomize					; used to produce unique instances of randomly generated numbers (so each string is truely random)
	call UserInt					; call to UserInt to retrieve the number of times L1 will iterate	
	
	mov ecx, eax					; eax contains user's input and this is stored in ecx and used as a counter
	mov edx, strPtr					; a pointer to strArray is placed into edx so that the program will always know its memory location
	L1:								; START MAIN LOOP
		mov eax, L					;		move L=30 into eax so it is passed to randStr later on	
		mov esi, edx				;		place pointer to strArray into esi
		call randStr				; 		call randStr create a logical string inside strArray containing ASCII values of random capital letters

		mov eax, 16					;       put range of random colors to be generated into eax to be passed to RandomRange (n=16, rng: [0, n-1])
		call RandomRange			;		call RandomRange to store the range of numbers corresponding to colors in eax
		call SetTextColor			;		call SetTextColor to use random value in range [0, 15] to produce random color of string to be generated
		
		push ecx					; 		save counter value of L1 to ESP
		
		mov ecx, L					; 		make the counter of L2 equal to the string length L=30
		mov esi, OFFSET strArray	; 		move the offset of strArray into esi so strArray can be iterated through using esi
		L2:							; START NESTED LOOP
			mov eax, [esi]			; 		move the current dereferenced location of strArray into eax to be passed into WriteChar
			call WriteChar			; 		call WriteChar to convert the ASCII value in the current location of strArray to a letter on the terminal		
			inc esi					;		move the the next location of strArray so the rest of its next element can be printed on the terminal
		loop L2						; END NESTED LOOP
		
		pop ecx						;		restore the counter value used by L1 to the stack so L1 can continue to properly iterate
		
		call Crlf					;		print a new line on the terminal to properly display the next string produced by the next iteration of L1
	loop L1							; END MAIN LOOP

	mov eax, 7						; store the number corresponding to the original terminal color in eax to be passed to SetTextColor
	call SetTextColor				; restore the text color on the terminal to its original color so that "Press any key to continue" is visible
	call WaitMsg					; lets the terminal stay on the screen for user to review. Program will exit once key is pressed.
	
	exit
main ENDP



;=========================================================================;
;-------------------------- UserInt PROCEDURE ----------------------------;
; Function: prompts the user to enter an integer into the terminal   	  ;
; Requires: string array containing prompt to be declared in a .data      ;
;			section      											 	  ;
; Recieves: nothing														  ;
; Returns:  integer that the user entered stored in eax					  ;
; Postcondition: eax contains user input that is passed back to main PROC ;
;=========================================================================;
UserInt PROC

	mov edx, OFFSET prompt1			; WriteString requires the offset of the string to be written to the terminal to be stored in edx
	call WriteString				; display prompt for user to enter an integer
	call ReadInt					; allow the user to enter an integer as prompted

	ret								; return to the main procedure
UserInt ENDP



;=======================================================================;
;------------------------- randStr PROCEDURE ---------------------------;
; Function: generates a random value corresponding to an ASCII code of  ;
;			a capital letter and stores these values in strArray        ;
; Requires: nothing														;
; Recieves: eax containing length of string and esi containing offset   ;
;			of strArray													;
; Returns:  nothing (string is produced within function, rather than 	;
;			passed back to main)										;
; Postcondition: strArray will have 30 elements, each containing a      ;
;				 random ASCII value corresponding to a capital letter   ;
;=======================================================================;
randStr PROC

	push ecx						; save value of ecx (L1 counter in main) to the ESP so ecx can be used as a counter for a loop in this procedure
	
	mov ecx, eax					; move eax containing L=30 to the counter for L1 in this procedure
	L1:								; START LOOP
		mov eax, 26					; 		put range of random ASCII values to be generated into eax to be passed to RandomRange (n=26, rng: [0, n-1])
		call RandomRange			; 		call RandomRange to store a random value in the specified range of ASCII values in eax
		add ax, 65					;		add 65 to whatever random value is in eax (capital letters in ASCII are 65d above 0)
		mov[esi], eax				; 		move random capital letter's ASCII value to the current location in strArray
		inc esi						; 		move esi to the next location of strArray so a random capital letter can be placed in its next element
	loop L1							; END LOOP
	
	pop ecx							; restore the value of ecx to the stack so that L1 in main can continue to properly iterate
	
	ret								; return to the main procedure
randStr ENDP


END main