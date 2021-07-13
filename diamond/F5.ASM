code segment
assume cs:code,ds:code
start:
	mov ax,code
	mov ds,ax

	mov dx,offset filename

	mov al,0	;file open
	mov ah,3dh
	int 21h

	mov bx,ax	;file read
	mov ah,3fh
	mov cx,19*5
	mov dx,offset name1
	int 21h

	mov ah,3eh	;file close
	int 21h

	push ax
	push bx

	mov al,n1sco1
	mov ah,n1sco10
	mov bl,n1sco
	call convert	;convert from score1(dec) to score1(hex)
	mov n1sco,bl

	mov al,n2sco1
	mov ah,n2sco10
	mov bl,n2sco
	call convert	;convert from score2(dec) to score2(hex)
	mov n2sco,bl

	mov al,n3sco1
	mov ah,n3sco10
	mov bl,n3sco
	call convert	;convert from score3(dec) to score3(hex)
	mov n3sco,bl

	mov al,n4sco1
	mov ah,n4sco10
	mov bl,n4sco
	call convert	;convert from score4(dec) to score4(hex)
	mov n4sco,bl

	mov al,n5sco1
	mov ah,n5sco10
	mov bl,n5sco
	call convert	;convert from score5(dec) to score5(hex)
	mov n5sco,bl

	pop bx
	pop ax
;	mov ax,4c00h	;exit
;	int 21h
	jmp l1

filename db "score.dat"
n1sco	db 00h
n2sco	db 00h
n3sco	db 00h
n4sco	db 00h
n5sco	db 00h
name1	db 15 dup (?)
n1sco10  db ?
n1sco1   db ?
sam1 dw ?
name2	db 15 dup (?)
n2sco10  db ?
n2sco1   db ?
sam2 dw ?
name3	db 15 dup (?)
n3sco10  db ?
n3sco1   db ?
sam3 dw ?
name4	db 15 dup (?)
n4sco10  db ?
n4sco1   db ?
sam4 dw ?
name5	db 15 dup (?)
n5sco10  db ?
n5sco1   db ?
sam5 dw ?
name6 db 10 dup (?)

convert:
	inc bl
	dec al
	cmp al,2fh
	jnz convert
	mov al,39h
	dec ah
	cmp ah,2fh
	jnz convert
	dec bl
	ret

l1:	mov ax,code
	mov ds,ax	

	mov si,offset db1
	mov di,offset w1
	call push_word		;1st word is formated as'             '

	mov si,offset db1
	mov di,offset w2
	call push_word		;2nd word is formated as'             '

	mov si,offset db1
	mov di,offset w3
	call push_word		;3rd word is formated as'             '

	mov si,offset db1
	mov di,offset w4
	call push_word		;4th word is formated as'             '

bgn:	mov si,offset db1
	mov ax,0b800h
	mov es,ax

	call cls
	call screen_inital
	call sc_left_up
	call sc_left_mid
	call sc_left_down
	call clear
	call input_box

	mov ax,code
	mov ds,ax	
	mov dx,offset nme

	mov ah,0ah	;string input
	int 21h

	push di		;delete max,len,CR in nme string buffer(int 21h(0ah))
	mov di,offset score2
	mov si,dx
	add si,2
	mov dx,10
g2:	mov al,ds:[si]
	cmp al,13
	jnz g1
	mov al,' '
g1:	mov ds:[di],al
	inc di
	inc si
	dec dx
	jnz g2
	pop di

	mov si, offset stl
	add si,16
	mov al,ds:[si]
	cmp al,52h
	jz i3

	mov ax,4c00h
	int 21h

i3:	call cls
	call screen_inital
	call sc_left_up
	call sc_left_mid
	call sc_left_down

;	mov ax,04c00h
;	int 21h
loop3:	call clear	;screen clear

	mov si,offset w1
	call calc_di_1
	mov bx, hgt1
	call dsp	;first word draw

	mov si,offset w2
	call calc_di_2
	mov bx, hgt2
	call dsp	;second word draw

	mov si,offset w3
	call calc_di_3
	mov bx, hgt3
	call dsp	;3th word draw

	mov si,offset w4
	call calc_di_4
	mov bx, hgt4
	call dsp	;4th word draw

	call inc_hegit
	call sc_left_mid

	push cx
	mov cx,20	;key_scan 0~20
loop9:
	call key_scan
	call dly
	dec cx
	jnz loop9
	pop cx
	jmp loop3

key_scan:
	mov ah,01h	;key_input
	int 16h

	jnz k_status	;if key pressed, jump k_status
	ret

k_status:

	mov ah,10h	;read key_buffer
	int 16h

	cmp al,27	;if esc_key, exit
	jnz input_wrd	;key_buff work and jump loop3


	mov ax,4c00h	;exit
	int 21h

input_wrd:
	push es
	push di
	push bx
	push cx

	cmp ah,81	;tempo down key
	jnz label1
	inc tempo
	cmp tempo,100	
	jnz l7
	mov bx,99
	mov tempo,bx
	jmp l5

l7:	dec tmp1
	cmp tmp1,2fh	;30-1=29 -> 39(0-1=-1 -> 9)
	jnz l5
	dec tmp10
	mov bl,39h
	mov tmp1,bl

l5:
	call sc_left_up
	call sc_left_mid
	call sc_left_down

	mov ah,15h
	mov di,80*2*21+8*2+1
	mov es:[di],ah
	call dly
	mov ah,1eh
	mov di,80*2*21+8*2+1
	mov es:[di],ah

	jmp label3

label1:	cmp ah,73	;tempo up key
	jnz label2
	dec tempo
	jnz lbl6
	mov ax,1	;if tempo=0 then tempo=1
	mov tempo,ax
	jmp l6
lbl6:	
	inc tmp1
	cmp tmp1,3ah	;39+1=3a -> 40(0+1=1 -> 11)
	jnz l6
	inc tmp10
	mov bl,30h
	mov tmp1,bl

l6:	call sc_left_up
	call sc_left_mid
	call sc_left_down

	mov ah,15h
	mov di,80*2*19+8*2+1
	mov es:[di],ah
	call dly
	mov ah,1eh
	mov di,80*2*19+8*2+1
	mov es:[di],ah

	jmp label3

label2:	cmp al,13	;Enter key ?
	jnz k_c1

	cmp key_buffID,00h
	jz label3		;when any key is pressed,do not compare
	jmp key_comp

k_c1:	cmp al,08	;08 is ascii "backspace"_key
	jnz lbl3
	push ax
	mov ax,1
	mov flag,ax
	pop ax
	dec key_buffID
	jns lbl4
	push ax
	mov ax,00h
	mov key_buffID,ax
	pop ax

lbl4:	mov al,20h	;"space" key

lbl3:	mov bl,al	;because ax is uesed to count es

	mov ax,code
	mov es,ax
  	mov di,offset key_buffer
     	add di,key_buffID
	mov es:[di],bl	;put input_key in key_buffer

	cmp flag,1
	jz lbl5
	inc key_buffID

lbl5:	
	push ax
	mov ax,0
	mov flag,ax
	pop ax
	cmp key_buffID,15;if key_buffer is full charged, key_buff=0
	js input_wrd1
	mov key_buffID,0
input_wrd1:
	push ax
	mov si, offset key_buffer
	mov ax,0b800h
	mov es,ax
	mov di,80*2*24+46*2
	mov cx,15
loop7:	mov al,ds:[si]
	mov es:[di],al
	inc di
	mov ah,74h	;color
	mov es:[di],ah
	inc si
	inc di
	dec cx
	jnz loop7
	pop ax
label3:
	pop cx
	pop bx
	pop di
	pop es

	ret

key_comp:
	mov ax,code
	mov ds,ax
	mov si,offset key_buffer
	mov di,offset w1
	mov cx,12	;for compare w1
key_comp1:
	inc si
	inc di
	mov bl,ds:[si-1]
	cmp bl,ds:[di-1]
	jnz key_comp21
	dec cx
	jnz key_comp1
	mov si,offset w1
	dec hgt1
	call calc_di_1	;in show_word di is offset from 0b800h
	mov bx,hgt1
	mov hgt1,20
	jmp sound

key_comp21:
	mov si,offset key_buffer
	mov di,offset w2
	mov cx,12	;for compare w2
key_comp2:
	inc si
	inc di
	mov bl,ds:[si-1]
	cmp bl,ds:[di-1]
	jnz key_comp31
	dec cx
	jnz key_comp2
	mov si,offset w2
	dec hgt2
	call calc_di_2	;in show_word di is offset from 0b800h
	mov bx,hgt2
	mov hgt2,20
	jmp sound
key_comp31:
	mov si,offset key_buffer
	mov di,offset w3
	mov cx,12	;for compare w3
key_comp3:
	inc si
	inc di
	mov bl,ds:[si-1]
	cmp bl,ds:[di-1]
	jnz key_comp41
	dec cx
	jnz key_comp3
	mov si,offset w3
	dec hgt3
	call calc_di_3	;in show_word di is offset from 0b800h
	mov bx,hgt3
	mov hgt3,20
	jmp sound

key_comp41:
	mov si,offset key_buffer
	mov di,offset w4
	mov cx,12	;for compare w4
key_comp4:
	inc si
	inc di
	mov bl,ds:[si-1]
	cmp bl,ds:[di-1]
	jnz buff_clear1
	dec cx
	jnz key_comp4
	mov si,offset w4
	dec hgt4
	call calc_di_4	;in show_word di is offset from 0b800h
	mov bx,hgt4
	mov hgt4,20

sound:	push tempo
	mov tempo,0fh	;when sound out delay tempo fix 3
	push ax
	mov ax,code
	mov ds,ax
	mov ax,0b800h
	mov es,ax

	mov al,23h
	out 61h,al	;out sound

	push di
	push si

	mov ah,9fh	;blink word as white color
	call show_word
	call dly
	call dly
	mov al,0h
	out 61h,al	;stop sound
	pop si
	pop di

	push di
	push si
	mov ah,9ah	;blink word as red color
	call show_word
	call dly
	call dly
	call dly

	pop si
	pop di

	mov ah,9bh	;blink word as blue color
	call show_word
	call dly
	call dly
	call dly
	call inc_hegit
	call inc_score
	pop ax
	pop tempo

buff_clear1:
	mov cx,15	;key_buffer's size
	mov si,offset key_buffer
buff_clear:
	mov al,20h
	mov ds:[si],al
	inc si
	dec cx
	jnz buff_clear
;	;Input_word clear in screen
	push ax
	mov si, offset key_buffer
	mov ax,0b800h
	mov es,ax
	mov di,80*2*24+46*2
	mov cx,15
loop8:	mov al,ds:[si]
	mov es:[di],al
	inc di
	mov ah,74h		;input key's color
	mov es:[di],ah
	inc si
	inc di
	dec cx
	jnz loop8

	pop ax

	pop cx
	pop bx
	pop di
	pop es
	mov key_buffID,0
	ret

dsp:	push cx		;screen display subroutine
	push di
	push si

	cmp bl,1
	js dsp1	;if height less 6 then 
	mov ah,1dh

dsp1:	cmp bl,8
	js dsp2
	mov ah,1eh

dsp2:	cmp bl,15
	js dsp3
	mov ah,1fh

dsp3:	call show_word

	pop si
	pop di
	pop cx
	ret

w1	db 15 dup (?)
w2	db 15 dup (?)
w3	db 15 dup (?)
w4	db 15 dup (?)
w5	db 15 dup (?)

blink_word db 15 dup (?)

tempo dw 50		;delay tempo;2

tmp_str1 db 'Tempo '
tmp_str2 db 1eh
tmp_str3 db ' :PageUp  '

tmp_str7 db ' Speed  :   '	;10
tmp10	db 35h		;35h=5	;1
tmp1	db 30h		;30h=0	;1
tmp_str8 db '   '	;3

tmp_str4 db 'Tempo '
tmp_str5 db 1fh
tmp_str6 db ' :PageDown'

flag dw 0	;when either backspace is pressed or unpress,  for separating	
hgt1	dw 7
hgt2	dw 2
hgt3	dw 4
hgt4	dw 5
hgt5	dw 10

lft1	dw 27*2
lft2	dw 39*2
lft3	dw 51*2
lft4	dw 63*2

nme db 12,?,11 dup (?)	;2  ...  12 is buffer size... ? is string length

score1 db 'Name  :'	;7
score2 db 10 dup (?)	;10	(17)
score3 db 'Total :  '	;9
total1000 db 30h	;1	(10)
total100 db 30h		;1	(11)
total10 db 30h		;1 	(12)
total1 db 30h		;1	(13)
score4 db 4 dup(?)	;4	(17)
score7 db 'Mark  :   '	;9
mark10 db 30h		;1	(10)
mark1 db 30h		;1	(11)
score8 db 5 dup(?)	;6	(17)
score5 db 'Score :  '	;9
sco1000 db 30h		;1	(10)
sco100 db 30h		;1	(11)
sco10 db 30h		;1	(12)
sco1 db 30h		;1	(13)
score6 db 4 dup(?)	;4	(17)

total dw 00h		;word counter
score dw 00h		;score counter
mark dw 00h
color1 	db '---Who is best?--'

color2 	db '------Tempo------'
color3 	db '------Score------'
color4	db 'ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍTraining StationÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ'
color5 	db 'ÄÄÄÄÄÄÄÄÄÄWELCOMEÄÄÄÄÄÄÄÄÄÄ'

key_buffer db 15 dup (' ')
key_buffID dw 00h
db1	db '            ','people      ';57 piece of words by 12 characters
db2	db 'dog         '
db3	db 'apple       ','            '
db4	db 'cat         ','            '
db5	db 'cake        '
db6	db 'map         ','            '
db7	db 'experience  '
db8	db 'employee    ','            '
db9	db 'enviroment  '
db10	db 'exploer     '
db11	db 'password    ','            '
db12	db 'compile     '
db13	db 'document    ','            '
db14	db 'random      '
db15	db 'memory      ','            '
db16	db 'private     '
db17	db 'public      ','            '
db18	db 'protect     '
db19	db 'detect      '
db20	db 'virus       ','            '
db21	db 'pascal      '
db22	db 'paint       '
db23	db 'pentium     ','            '
db24	db 'wordpad     '
db25	db 'access      ','            '
db26	db 'sound       '
db27	db 'picture     ','            '
db28	db 'hardware    '
db29	db 'office      ','            '
db30	db 'science     '
db31	db 'program     ','            '
db32	db 'paste       '
db33	db 'property    ','            '
db34	db 'print       '
db35	db 'popin       ','            '
db36	db 'attribute   '
db37	db 'assign      ','            '
db38	db 'object      '
db39	db 'project     ','            '
db40	db 'module      '
db41	db 'error       ','            '
db42	db 'struct      ','            '
db43	db 'architecture'
db44	db 'template    ','            '
db45	db 'keyboard    '
db46	db 'software    '
db47	db 'freeware    ','            '
db48	db 'microsoft   '
db49	db 'window      ','            '
db50	db 'studio      '
db51	db 'floppy      ','            '
db52	db 'copyright   '
db53	db 'screen      ','            '
db54	db 'space       '
db55	db 'system      '
db56	db 'displacement','            '
db57	db 'internet    '
db58	db 'compatiable ','            '
db59	db 'double      '
db60    db 'script      '
db61	db 'pascal      ','            '
db62	db 'paint       '
db63	db 'pentium     ','            '
db64	db 'wordpad     '
db65	db 'access      ','            '
db66	db 'sound       '
db67	db 'picture     '
db68	db 'hardware    ','            '
db69	db 'office      '
db70	db 'science     '
db71	db 'program     ','            '
db72	db 'paste       '
db73	db 'property    ','            '
db74	db 'print       '
db75	db 'popin       ','            '
db76	db 'attribute   '
db77	db 'assign      ','            '
db78	db 'object      '
db79	db 'project     '
db80	db 'module      ','            '
db81	db 'error       '
db82	db 'struct      '
db83	db 'architecture','            '
db84	db 'template    '
db85	db 'keyboard    ','            '
db86	db 'software    '
db87	db 'freeware    ','            '
db88	db 'microsoft   '
db89	db 'window      ','            '
db90	db 'studio      '
db91	db 'floppy      '
db92	db 'copyright   ','            '
db93	db 'screen      '
db94	db 'space       ','            '
db95	db 'system      '
db96	db 'displacement','            '
db97	db 'internet    '
db98	db 'compatiable ','            '
db99	db 'double      '
db100	db 'double      ','            '
db190	db 'studio      '
db191	db 'floppy      '
db192	db 'copyright   ','            '
db193	db 'screen      '
db194	db 'space       ','            '
db195	db 'system      '
db196	db 'displacement','            '
db197	db 'internet    '
db198	db 'compatiable ','            '
db199	db 'double      '
ttl  db '    Product By K.U.T comupter'
stl  db ' department 3-2 Ryang Song Chol & Cheo Chung Il             '
clear:	push cx		;screen clear subroutine
	push di
	push si
	mov di,80*2*2 + 26*2

	mov cx,20
loop2_1:
	push cx

	mov cx,78-29	;total count
	mov ah,01h	;color 
loop2:	call draw_Û
	dec cx
	jnz loop2

	add di,31*2	;26=24+2
	pop cx
	dec cx
	jnz loop2_1

	pop si
	pop di
	pop cx
	
	ret

dly:	push cx		;time delay subroutine
	push bx
	push ax

	mov ax,tempo	;delay tempo
	mov bx,ax
loop5:	mov cx,03fffh
loop4:	dec cx
	jnz loop4
	dec bx
	jnz loop5

	pop ax
	pop bx
	pop cx
	ret

screen_inital:
	mov ax, 0b800h
	mov es,ax
	mov di,80*2+24*2;begin after 20 space
	mov si,offset color4
	mov ah,01h
	call draw_Û
	mov cx,78-29	;when draw 'Í',	counter

	mov al,201	;201 is ascii of 'É'
	mov ah,1fh
	mov es:[di],al
	inc di
	mov es:[di],ah	
	inc di		;left-up coner draw end
	
screen_loop1:
	mov al,ds:[si]	; 205 is ascii of 'Í'
	mov es:[di],al
	inc si 
	inc di
	mov es:[di], ah
	inc di
	dec cx
	jnz screen_loop1; upline draw end

	mov al,187
	mov es:[di],al
	inc di
	mov es:[di],ah	
	inc di		;right-up coner '»' draw end

	mov ah,01h
	call draw_Û
	add di,4
	mov al,186
	mov cx,20	;begin 'º'
screen_loop3:
	add di,25*2
	mov al,219
	mov ah,01h
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di

	mov al,186
	mov ah,1fh
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	add di,49*2	;50=78-28
	mov al,186
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	mov ah,01h	;color
	call draw_Û
	call shadow
	call shadow
;	sub di,2	;to use counting di below
	dec cx
	jnz screen_loop3

	add di,25*2
	mov al,219
	mov ah,01h
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	mov al,200	;draw 'È'
	mov ah,1fh
	mov es:[di],al
	inc di
	mov es:[di],ah	
	inc di		;left-down coner draw end
	
	mov cx,78-29
	mov al,205	; 205 is ascii of 'Í'
screen_loop2:
	mov es:[di],al
	inc di
	mov es:[di], ah
	inc di
	dec cx
	jnz screen_loop2; downline draw end

	mov al,188	;draw '¼'
	mov es:[di],al
	inc di
	mov es:[di],ah	
	inc di		;right-down coner draw end
	mov ah,01h	;color
	call draw_Û

	call shadow
	call shadow
	
	mov cx,53
	add di,27*2
screen_loop4:
	call shadow
	dec cx
	jnz screen_loop4;training station shadow sraw end
	ret

show_word:
	mov cx,12	;A word's length is 12
loop1:	mov al,ds:[si]
	mov es:[di],al
	inc di

	mov es:[di],ah

	inc di
	inc si

	dec cx
	jnz loop1
	ret

get_random:
	mov ah, 2ch	;get dos time
	int 21h

	mov ah,0h
	mov al,dl	;dh register is memoried 1second/100
	add al,dh	;dh register is memoried second
	mov dx,12	;most long word's lenght is 12
	mul dx
	ret

inital_w1_w5:
	call inital_w1
	call inital_w2
	call inital_w3
	call inital_w4
	ret
inital_w1:
			;fisrt word push in w1
	call inital_common
	mov di,offset w1
	call push_word
	ret

inital_w2:
			;second word push in w2
	call inital_common
	mov di,offset w2
	call push_word
	ret

inital_w3:
			;3th word push in w3
	call inital_common
	mov di,offset w3
	call push_word
	ret

inital_w4:
			;4th word push in w4
	call inital_common
	mov di,offset w4
	call push_word
	ret

inital_common:
	mov si, offset db1
	call get_random
	add si,ax

	mov al,ds:[si]
	cmp al,' '
	jz i1

	inc total
	inc total1
	cmp total1,3ah
	jnz i1
	mov total1,30h
	inc total10
	cmp total10,3ah
	jnz i1
	mov total10,30h
	inc total100
	cmp total100,3ah
	jnz i1
	mov total100,30h
	inc total1000
	cmp total1000,3ah
	jnz i1
	mov total1000,30h
i1:	ret

push_word:
	mov cx ,12
p_w_loop1:
	mov bl,ds:[si]
	mov ds:[di],bl
	inc di
	inc si
	dec cx
	jnz p_w_loop1
	ret

inc_hegit:

	mov bx,hgt1	;
	inc bx		;
	mov hgt1,bx	;hgt1=hgt1+1

	cmp hgt1,21	;	
	jnz i_h_1	;
	mov hgt1,1	;if height over 22 then heght=1
	call inital_w1
	
i_h_1:
	mov bx,hgt2	;
	inc bx		;
	mov hgt2,bx	;hgt2=hgt2+1

	cmp hgt2,21	;
	jnz i_h_2	;
	mov hgt2,1	;if height over 22 then heght=1
	call inital_w2
i_h_2:

	mov bx,hgt3	;
	inc bx		;
	mov hgt3,bx	;hgt3=hgt3+1

	cmp hgt3,21	;
	jnz i_h_3	;
	mov hgt3,1	;if height over 22 then heght=1
	call inital_w3
i_h_3:
	mov bx,hgt4	;
	inc bx		;
	mov hgt4,bx	;hgt4=hgt4+1

	cmp hgt4,21	;
	jnz i_h_4	;
	mov hgt4,1	;if height over 22 then heght=1
	call inital_w4
i_h_4:
	call count_mark
	ret
	

calc_di_1:
	push ax
	push bx
	mov ax,hgt1
	mov bh,80*2	;
	mul bh		;
	add ax,80*2	;
	add ax,lft1	;new di=height*80*2+80*2+lft1
	mov di,ax
	pop bx
	pop ax
	ret

calc_di_2:
	push ax
	push bx
	mov ax,hgt2
	mov bh,80*2	;
	mul bh		;
	add ax,80*2	;
	add ax,lft2	;new di=height*80*2+80*2+lft2
	mov di,ax
	pop bx
	pop ax
	ret

calc_di_3:
	push ax
	push bx
	mov ax,hgt3
	mov bh,80*2	;
	mul bh		;
	add ax,80*2	;
	add ax,lft3	;new di=height*80*2+80*2+lft3
	mov di,ax
	pop bx
	pop ax
	ret

calc_di_4:
	push ax
	push bx
	mov ax,hgt4
	mov bh,80*2	;
	mul bh		;
	add ax,80*2	;
	add ax,lft4	;new di=height*80*2+80*2+lft4
	mov di,ax
	pop bx
	pop ax
	ret

draw_Û:	mov al,219	;'Û'
	mov es:[di],al
	inc di
;	mov ah,01h
	mov es:[di],ah
	inc di
	ret
shadow:	mov al,219	;'Û'
	mov es:[di],al
	inc di
	mov ah,00h
	mov es:[di],ah
	inc di
	ret

sc_left_up:
	mov ax,0b800h
	mov es,ax
	mov di,80*2
	mov si,offset color1
	mov ah,01h	;color
	call draw_Û
	mov ah,1fh
	mov al,218	;'Ú'
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	mov cx,17
s_l_u1:	mov al,ds:[si]
	inc si
	mov es:[di],al
	inc di
	mov es:[di], ah
	inc di
	dec cx
	jnz s_l_u1

	mov ah,1fh
	mov al,191	;'¿'
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	mov ah,01h	;color
	call draw_Û

	mov si,offset name1
	mov cx,5
s_l_u3:	add di,80*2-21*2
	mov ah,01h	;color
	call draw_Û
	mov al,'³'	;179
	mov ah,1fh
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	push cx
	mov cx,17
s_l_u2:	mov al,ds:[si]
	mov ah,1ah
	mov es:[di],al
	inc di
	inc si
	mov es:[di],ah
	inc di
	dec cx
	jnz s_l_u2

	add si,2	;2 is db command's size

	pop cx
	mov al,'³'
	mov ah,1fh
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	mov ah,01h	;color
	call draw_Û
	call shadow
	call shadow
	sub di,4
	dec cx
	jnz s_l_u3

	add di,80*2-21*2
	mov ah,01h	;color
	call draw_Û
	mov ah,1fh
	mov al,192	;'À'
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	mov al,'-'	
	mov cx,17
s_l_u4:	mov es:[di],al
	inc di
	mov es:[di], ah
	inc di
	dec cx
	jnz s_l_u4

	mov ah,1fh
	mov al,217	;'Ù'
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	mov ah,01h	;color
	call draw_Û
	call shadow
	call shadow

	add di,80*2-21*2
	mov cx,21
s_l_u5: call shadow
	dec cx
	jnz s_l_u5
	sub di,4	;because shadow , down draw di to count unchange
	ret 

sc_left_mid:
	mov ax,0b800h
	mov es,ax
	mov di,80*2*10
	mov si,offset color3
	mov ah,01h	;color
	call draw_Û
	mov ah,1fh
	mov al,218	;'Ú'
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	mov cx,17
s_l_m1:	mov al,ds:[si]
	inc si
	mov es:[di],al
	inc di
	mov es:[di], ah
	inc di
	dec cx
	jnz s_l_m1

	mov ah,1fh
	mov al,191	;'¿'
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	mov ah,01h	;color
	call draw_Û

	mov si,offset score1
	mov cx,4
s_l_m3:	add di,80*2-21*2
	mov ah,01h	;color
	call draw_Û
	mov al,179	;'³'
	mov ah,1fh
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	push cx
	mov cx,17

	mov ah,1ch
s_l_m2: mov al,ds:[si]
	inc si
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	dec cx
	jnz s_l_m2
	pop cx
	mov al,179	;'³'
	mov es:[di],al
	inc di
	mov ah,1fh	;color
	mov es:[di],ah
	inc di
	mov ah,01h	;color
	call draw_Û
	call shadow
	call shadow
	sub di,4
	dec cx
	jnz s_l_m3

	add di,80*2-21*2
	mov ah,01h	;color
	call draw_Û
	mov ah,1fh
	mov al,192	;'À'
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	mov al,'-'
	mov cx,17
s_l_m4:	mov es:[di],al
	inc di
	mov es:[di], ah
	inc di
	dec cx
	jnz s_l_m4

	mov ah,1fh
	mov al,217	;'Ù'
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	mov ah,01h	;color
	call draw_Û
	call shadow
	call shadow

	add di,80*2-21*2
	mov cx,21
s_l_m5: call shadow
	dec cx
	jnz s_l_m5
	sub di,4	;because shadow , down draw di to count unchange
	ret 

sc_left_down:
	mov ax,0b800h
	mov es,ax
	add di,80*2*2-21*2
	mov si,offset color2
	mov ah,01h	;color
	call draw_Û
	mov ah,1fh
	mov al,218	;'Ú'
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	mov cx,17
s_l_d1:	mov al,ds:[si]
	inc si
	mov es:[di],al
	inc di
	mov es:[di], ah
	inc di
	dec cx
	jnz s_l_d1

	mov ah,1fh
	mov al,191	;'¿'
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	mov ah,01h	;color
	call draw_Û

	mov si,offset tmp_str1
	mov cx,3
s_l_d3:	add di,80*2-21*2
	mov ah,01h	;color
	call draw_Û
	mov al,179	;'³'
	mov ah,1fh
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	push cx
	mov cx,17
s_l_d2: mov ah,1eh
	mov al,ds:[si]
	mov es:[di],al
	inc di
	inc si
	mov es:[di],ah
	inc di
	dec cx
	jnz s_l_d2
	pop cx
	mov ah,1fh
	mov al,179	;'³'
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	mov ah,01h	;color
	call draw_Û
	call shadow
	call shadow
	sub di,4
	dec cx
	jnz s_l_d3

	add di,80*2-21*2
	mov ah,01h	;color
	call draw_Û
	mov ah,1fh
	mov al,192	;'À'
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	mov al,'-'	
	mov cx,17
s_l_d4:	mov es:[di],al
	inc di
	mov es:[di], ah
	inc di
	dec cx
	jnz s_l_d4

	mov ah,1fh
	mov al,217	;'Ù'
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	mov ah,01h	;color
	call draw_Û
	call shadow
	call shadow

	add di,80*2-21*2
	mov cx,21
s_l_d5: call shadow
	dec cx
	jnz s_l_d5
	sub di,4	;because shadow , down draw di to count unchange
	ret 

cls:	mov ax,0b800h
	mov es,ax
	mov di,0
	mov si,offset ttl
	mov cx,80
	mov ah,79h
cls2:	mov al,ds:[si]
	mov es:[di],al
	inc si
	inc di
	mov es:[di],ah
	inc di
	dec cx
	jnz cls2

	mov ah,07h	;color
	mov al,219	;'Û'
	mov cx,79*2*25
cls1:	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	dec cx
	jnz cls1
	ret

input_box:
	mov ax,0b800h
	mov es,ax
	mov di,80*2*9+23*2
	mov si,offset color5
	mov ah,05h	;color
	call draw_Û
	mov ah,5fh
	mov al,218	;'Ú'
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	mov al,196	;'Ä'
	mov cx,27
i_b_1:	mov al,ds:[si]
	inc si
	mov es:[di],al
	inc di
	mov es:[di], ah
	inc di
	dec cx
	jnz i_b_1

	mov ah,5fh
	mov al,191	;'¿'
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	mov ah,05h	;color
	call draw_Û

	mov cx,4
i_b_3:	add di,80*2-31*2
	mov ah,05h	;color
	call draw_Û
	mov al,179	;'³'
	mov ah,5fh
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	push cx
	mov cx,27
	mov al,' '
	mov ah,5fh
i_b_2:  mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	dec cx
	jnz i_b_2
	pop cx
	mov al,179	;'³'
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	mov ah,05h	;color
	call draw_Û
	call shadow
	call shadow
	sub di,4
	dec cx
	jnz i_b_3

	add di,80*2-31*2
	mov ah,05h	;color
	call draw_Û
	mov ah,5fh
	mov al,192	;'À'
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	mov al,196	;'Ä'
	mov cx,27
i_b_4:	mov es:[di],al
	inc di
	mov es:[di], ah
	inc di
	dec cx
	jnz i_b_4

	mov ah,5fh
	mov al,217	;'Ù'
	mov es:[di],al
	inc di
	mov es:[di],ah
	inc di
	mov ah,05h	;color
	call draw_Û
	call shadow
	call shadow

	add di,80*2-31*2
	mov cx,31
i_b_5:  call shadow
	dec cx
	jnz i_b_5
	sub di,4	;because shadow , down draw di to count unchange

	mov al,186	;'º'
	mov di,80*2*15+25*2
	mov es:[di],al
	inc di
	mov ah,07h
	mov es:[di],ah
	ret 
	
inc_score:
	inc score
	inc sco1
	cmp sco1,3ah
	jnz i2
	mov sco1,30h
	inc sco10
	cmp sco10,3ah
	jnz i2
	mov sco10,30h
	inc sco100
	cmp sco100,3ah
	jnz i2
	mov sco100,30h
	inc sco1000
	cmp sco1000,3ah
	jnz i2
	mov sco1000,30h
i2:	ret

count_mark:		;mark=score*(100-tempo)/total
	push ax
	push bx

	mov ax,100
	mov bx,tempo
	sub ax,bx
	mov bx,ax

	mov ax,score
	cmp ax,00h
	jz c_m3
	mul bx
	mov bx,total
	cmp bx,00h
	jz c_m3
	div bx
	mov mark,ax
	mov mark1,30h
	mov mark10,30h
c_m1:	inc mark1
	cmp mark1,3ah
	jnz c_m2
	mov mark1,30h
	inc mark10
	cmp mark10,3ah
	jnz c_m2
	mov mark10,30h
	
c_m2:	dec ax
	jnz c_m1

c_m3:	pop bx
	pop ax

	ret
code ends
	end start