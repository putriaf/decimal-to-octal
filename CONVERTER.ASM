; Program Mengubah Bilangan Desimal Menjadi Bilangan Oktal
; Sebuah angka dibagi dengan 8 sampai dengan hasil baginya 0, masing-masing sisanya disimpan dan ditampilkan (diurutkan dari sisa paling akhir)

org 0x100           ; origin 100 (hexadecimal), codingan mulai dieksekusi dari 100, biasanya codingan di dos dimulai dari byte ke-256 atau hex 100
global start
section .text

start:
    mov ah, 9h      ; mencetak string
    mov dx, teks    ; move string teks ke dx
    int 21h         ; menjalankan perintah
	mov ax, 1345    ; move ke ax, untuk mencetak
	mov bx, 8       ; ax dibagi oleh bx (8)
	mov cx, 0h      ; menghitung digit

division:          
    ; membagi bilangan dengan 8 lalu menyimpan sisanya
    mov dx, 0h      ; nilai dx dibikin kosong
    div bx          ; bagi oleh 8, sisa bakal ada di dx
    push dx         ; agar hasil tidak terbalik urutannya, maka push ke stack (konsep LIFO)
    				; sebelum pengulangan : <- stack
    				; pengulangan 1 : 1 (sisa dari 1345/8) <- stack top; 1345/8 = 168 dengan sisa 1
    				; pengulangan 2 : 0 1 <- stack top; 168/8 = 21 dengan sisa 0
    				; pengulangan 3 : 5 0 1 <- stack top; 21/8 = 2 dengan sisa 5
                    ; pengulangan 4 : 2 5 0 1 <- stack top; 2/8 = 0 dengan sisa 2
    inc cx			; increment jumlah digit
    cmp ax, 0       ; kalo angka udah abis dibagi semua berarti ax = 0
    jne division    ; jump not equal, kalo ax !=0, masih ada angka maka akan kembali ke awal division.

print:
    pop dx          ; ambil dan hapus dari stack ke dx
                    ; sebelum pengulangan : 2 5 0 1 <- stack top; dx = belum tau
                    ; pengulangan 1 : 5 0 1 <- stack top; dx = 2
                    ; pengulangan 2 : 0 1 <- stack top; dx = 5
                    ; pengulangan 3 : 1 <- stack top; dx = 0
                    ; pengulangan 4 : <- stack top; dx = 1
    add dl, 30h     ; untuk mengubah nilai didalam stack menjadi nilai ascii
    mov ah, 2h      ; interrupt buat cetak 1 character
    int 21h         ; menjalankan perintah
    dec cx          ; decrement jumlah digit
    jnz print       ; jump if not zero kalo masih ada digit (cx !=0), masuk ke looping lagi buat print
    mov ah, 4ch     ; interrupt buat exit
    mov al, 0       ; return 0
    int 21h         ; menjalankan perintah

section .data
teks : db "Bilangan Oktal dari 1345(10) adalah $"

