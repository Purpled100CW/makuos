org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

;
; FAT12 Header(unfortunately)
;

jmp short start 
nop

bdb_oem:                    db 'MSWIN4.1'           ; 8 bytes
bdb_bytes_per_sector:       dw 512
bdb_sectors_per_cluster:    db 1
bdb_reserved_sectors:       dw 1
bdb_fat_count:              db 2
bdb_dir_entries_count:      dw 0E0h
bdb_total_sectors:          dw 2880                 ; 2880 * 512 = 1.44 MB
bdb_media_descriptor_type:  db 0F0h                 ; F0 = 3.5" floppy disk
bdb_sectors_per_fat:        dw 9                    ; 9 sectors/fat
bdb_sectors_per_track:      dw 18   
bdb_heads:                  dw 2
bdb_hidden_sectors:         dd 0
bdb_large_sector_count:     dd 0

; extended boot record
ebr_drive_number:           db 0                    ; 0x00 = floppy, 0x80 = hard drive
                            db 0                    ; reserved
ebr_signature:              db 29h
ebr_volume_id:              db 12h, 15h, 45h, 36h   ; serial number
ebr_volume_label:           db 'MAKU     OS'        ; should be padded with spaces
ebr_system_id:              db 'FAT12'

start:
    jmp main

; Prints a string to the screen
; Parameters:
;   - ds:si points to string
puts:
    ; save register we will modify
    push si 
    push ax

.loop:
    lodsb       ; next char
    or al, al   ; verify if next char is null
    jz .done

    mov ah, 0x0e ; call bios interrupt(video mode)
    mov bh, 0
    int 0x10
    jmp .loop

.done:
    pop ax
    pop si
    ret

; Main driver code
main:
    ;setup a data segments
    mov ax, 0
    mov ds, ax
    mov es, ax

    ;setup stack
    mov ss, ax
    mov sp, 0x7C00

    ;print message
    mov si, msg_hello
    call puts
    hlt

.halt:
    jmp .halt

;
; Some disk routines
;

;
; Converts an LBA address to a CHS address
; Parameters
;   - ax: LBA address
; Returns:
;   - cx [bits 0-5]: sector number
;   - cx [bits 6-15]: cyclinder
;   - dh: head
;   
lba_to_chs:
    push ax
    push dx

    xor dx, dx  ; dx = 0
    div word [bdb_sectors_per_track]

    inc dx
    mov cx, dx
    div word [bdb_heads]

    mov dh, dl
    mov ch, al
    shl ah, 6
    or cl, ah

    pop ax
    mov dl, al
    pop dx
    ret


disk_read:
    
msg_hello: db 'Hello mf world!', ENDL, 0

times 510-($-$$) db 0 
dw 0AA55h