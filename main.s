	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 12, 0	sdk_version 12, 1
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #112                    ; =112
	stp	x29, x30, [sp, #96]             ; 16-byte Folded Spill
	add	x29, sp, #96                    ; =96
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	stur	x8, [x29, #-8]
	stur	wzr, [x29, #-36]
	stur	w0, [x29, #-40]
	str	x1, [sp, #48]
	str	x2, [sp, #40]
	adrp	x8, l___const.main.fileName@PAGE
	add	x8, x8, l___const.main.fileName@PAGEOFF
	ldr	q0, [x8]
	stur	q0, [x29, #-32]
	ldrh	w8, [x8, #16]
	sturh	w8, [x29, #-16]
	adrp	x0, l_.str@PAGE
	add	x0, x0, l_.str@PAGEOFF
	bl	_getenv
	str	x0, [sp, #24]
	cbnz	x0, LBB0_2
; %bb.1:
	adrp	x8, ___stderrp@GOTPAGE
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
	ldr	x1, [x8]
	adrp	x0, l_.str.1@PAGE
	add	x0, x0, l_.str.1@PAGEOFF
	bl	_fputs
	mov	w8, #123
	stur	w8, [x29, #-36]
	b	LBB0_6
LBB0_2:
	sub	x0, x29, #32                    ; =32
	adrp	x1, l_.str.2@PAGE
	add	x1, x1, l_.str.2@PAGEOFF
	bl	_fopen
	str	x0, [sp, #32]
	cbnz	x0, LBB0_4
; %bb.3:
	ldr	x0, [sp, #24]
	adrp	x8, ___stdoutp@GOTPAGE
	ldr	x8, [x8, ___stdoutp@GOTPAGEOFF]
	ldr	x1, [x8]
	bl	_fputs
	ldr	x0, [sp, #32]
	bl	_fclose
	stur	wzr, [x29, #-36]
	b	LBB0_6
LBB0_4:
; %bb.5:
	adrp	x0, l_.str.3@PAGE
	add	x0, x0, l_.str.3@PAGEOFF
	bl	_printf
	ldr	x0, [sp, #32]
	ldr	x8, [sp, #24]
	adrp	x1, l_.str.4@PAGE
	add	x1, x1, l_.str.4@PAGEOFF
	mov	x9, sp
	str	x8, [x9]
	bl	_fprintf
	ldr	x0, [sp, #32]
	bl	_fclose
	stur	wzr, [x29, #-36]
LBB0_6:
	ldur	w8, [x29, #-36]
	str	w8, [sp, #20]                   ; 4-byte Folded Spill
	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	ldur	x9, [x29, #-8]
	subs	x8, x8, x9
	b.ne	LBB0_8
; %bb.7:
	ldr	w0, [sp, #20]                   ; 4-byte Folded Reload
	ldp	x29, x30, [sp, #96]             ; 16-byte Folded Reload
	add	sp, sp, #112                    ; =112
	ret
LBB0_8:
	bl	___stack_chk_fail
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l___const.main.fileName:                ; @__const.main.fileName
	.asciz	"Result-output.txt"

l_.str:                                 ; @.str
	.asciz	"HOME"

l_.str.1:                               ; @.str.1
	.asciz	"Error 123. Home is not set."

l_.str.2:                               ; @.str.2
	.asciz	"w"

l_.str.3:                               ; @.str.3
	.asciz	"Hello world!"

l_.str.4:                               ; @.str.4
	.asciz	"%s\n"

.subsections_via_symbols
