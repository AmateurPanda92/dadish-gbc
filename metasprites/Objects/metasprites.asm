;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler 
; Version 4.4.1 #14650 (MINGW64)
;--------------------------------------------------------
	.module metasprites
	.optsdcc -msm83
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _load_and_duplicate_sprite_tile_data
	.globl _get_tile_offset
	.globl _set_tile
	.globl _hide_sprites_range
	.globl _cgb_compatibility
	.globl _set_sprite_palette
	.globl _fill_bkg_rect
	.globl _set_sprite_data
	.globl _set_bkg_data
	.globl _display_off
	.globl _vsync
	.globl _joypad
	.globl _old_joyp
	.globl _joyp
	.globl _num_tiles
	.globl _flipped_data
	.globl _rot
	.globl _idx
	.globl _PosF
	.globl _SpdY
	.globl _SpdX
	.globl _PosY
	.globl _PosX
	.globl _green_pal
	.globl _cyan_pal
	.globl _pink_pal
	.globl _gray_pal
	.globl _reverse_bits
	.globl _pattern
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_PosX::
	.ds 2
_PosY::
	.ds 2
_SpdX::
	.ds 2
_SpdY::
	.ds 2
_PosF::
	.ds 1
_idx::
	.ds 1
_rot::
	.ds 1
_flipped_data::
	.ds 16
_num_tiles::
	.ds 2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_joyp::
	.ds 1
_old_joyp::
	.ds 1
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;src/metasprites.c:94: void set_tile(uint8_t tile_idx, uint8_t* data, uint8_t flip_x, uint8_t flip_y)
;	---------------------------------
; Function set_tile
; ---------------------------------
_set_tile::
	add	sp, #-9
	ldhl	sp,	#6
	ld	(hl-), a
	dec	hl
	ld	a, e
	ld	(hl+), a
;src/metasprites.c:97: for(i = 0; i < TILE_HEIGHT; i++)
	ld	a, d
	ld	(hl+), a
	inc	hl
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
00102$:
;src/metasprites.c:99: size_t y = flip_y ? (TILE_HEIGHT-1-i) : i; 
	ldhl	sp,	#12
	ld	a, (hl)
	or	a, a
	jr	Z, 00106$
	ld	de, #0x0007
	ldhl	sp,	#7
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#3
	ld	(hl-), a
	ld	(hl), e
	jr	00107$
00106$:
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl+), a
	ld	(hl), #0x00
00107$:
	ldhl	sp,	#2
	ld	c, (hl)
	ld	b, #0x00
;src/metasprites.c:100: flipped_data[2*i] = flip_x ? reverse_bits[data[2*y]] : data[2*y];
	ldhl	sp,	#7
	ld	a, (hl)
	add	a, a
	ldhl	sp,	#1
	ld	(hl), a
	ld	e, a
	rlca
	sbc	a, a
	ld	d, a
	ld	hl, #_flipped_data
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl+), a
	sla	c
	rl	b
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	e, a
	ldhl	sp,	#11
	ld	a, (hl)
	or	a, a
	jr	Z, 00108$
	ld	hl, #_reverse_bits
	ld	d, #0x00
	add	hl, de
	ld	a, (hl)
	jr	00109$
00108$:
	ld	a, e
00109$:
	ldhl	sp,	#2
	push	af
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	pop	af
	ld	(hl), a
;src/metasprites.c:101: flipped_data[2*i+1] = flip_x ? reverse_bits[data[2*y+1]] : data[2*y+1];
	ldhl	sp,	#1
	ld	a, (hl)
	inc	a
	ld	e, a
	rlca
	sbc	a, a
	ld	d, a
	ld	hl, #_flipped_data
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	inc	bc
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	e, a
	ldhl	sp,	#11
	ld	a, (hl)
	or	a, a
	jr	Z, 00110$
	ld	d, #0x00
	ld	hl, #_reverse_bits
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	jr	00111$
00110$:
	ld	c, e
00111$:
	pop	hl
	push	hl
	ld	(hl), c
;src/metasprites.c:97: for(i = 0; i < TILE_HEIGHT; i++)
	ldhl	sp,	#7
	inc	(hl)
	jr	NZ, 00149$
	inc	hl
	inc	(hl)
00149$:
	ldhl	sp,	#7
	ld	a, (hl+)
	sub	a, #0x08
	ld	a, (hl)
	sbc	a, #0x00
	jp	C, 00102$
;src/metasprites.c:103: set_sprite_data(tile_idx, 1, flipped_data);
	dec	hl
	dec	hl
	ld	de, #_flipped_data
	push	de
	ld	a, #0x01
	push	af
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_sprite_data
;src/metasprites.c:104: }
	add	sp, #13
	pop	hl
	pop	af
	jp	(hl)
_pattern:
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x40	; 64
	.db #0x40	; 64
	.db #0x20	; 32
	.db #0x20	; 32
	.db #0x10	; 16
	.db #0x10	; 16
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x04	; 4
	.db #0x04	; 4
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x01	; 1
	.db #0x01	; 1
_reverse_bits:
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x40	; 64
	.db #0xc0	; 192
	.db #0x20	; 32
	.db #0xa0	; 160
	.db #0x60	; 96
	.db #0xe0	; 224
	.db #0x10	; 16
	.db #0x90	; 144
	.db #0x50	; 80	'P'
	.db #0xd0	; 208
	.db #0x30	; 48	'0'
	.db #0xb0	; 176
	.db #0x70	; 112	'p'
	.db #0xf0	; 240
	.db #0x08	; 8
	.db #0x88	; 136
	.db #0x48	; 72	'H'
	.db #0xc8	; 200
	.db #0x28	; 40
	.db #0xa8	; 168
	.db #0x68	; 104	'h'
	.db #0xe8	; 232
	.db #0x18	; 24
	.db #0x98	; 152
	.db #0x58	; 88	'X'
	.db #0xd8	; 216
	.db #0x38	; 56	'8'
	.db #0xb8	; 184
	.db #0x78	; 120	'x'
	.db #0xf8	; 248
	.db #0x04	; 4
	.db #0x84	; 132
	.db #0x44	; 68	'D'
	.db #0xc4	; 196
	.db #0x24	; 36
	.db #0xa4	; 164
	.db #0x64	; 100	'd'
	.db #0xe4	; 228
	.db #0x14	; 20
	.db #0x94	; 148
	.db #0x54	; 84	'T'
	.db #0xd4	; 212
	.db #0x34	; 52	'4'
	.db #0xb4	; 180
	.db #0x74	; 116	't'
	.db #0xf4	; 244
	.db #0x0c	; 12
	.db #0x8c	; 140
	.db #0x4c	; 76	'L'
	.db #0xcc	; 204
	.db #0x2c	; 44
	.db #0xac	; 172
	.db #0x6c	; 108	'l'
	.db #0xec	; 236
	.db #0x1c	; 28
	.db #0x9c	; 156
	.db #0x5c	; 92
	.db #0xdc	; 220
	.db #0x3c	; 60
	.db #0xbc	; 188
	.db #0x7c	; 124
	.db #0xfc	; 252
	.db #0x02	; 2
	.db #0x82	; 130
	.db #0x42	; 66	'B'
	.db #0xc2	; 194
	.db #0x22	; 34
	.db #0xa2	; 162
	.db #0x62	; 98	'b'
	.db #0xe2	; 226
	.db #0x12	; 18
	.db #0x92	; 146
	.db #0x52	; 82	'R'
	.db #0xd2	; 210
	.db #0x32	; 50	'2'
	.db #0xb2	; 178
	.db #0x72	; 114	'r'
	.db #0xf2	; 242
	.db #0x0a	; 10
	.db #0x8a	; 138
	.db #0x4a	; 74	'J'
	.db #0xca	; 202
	.db #0x2a	; 42
	.db #0xaa	; 170
	.db #0x6a	; 106	'j'
	.db #0xea	; 234
	.db #0x1a	; 26
	.db #0x9a	; 154
	.db #0x5a	; 90	'Z'
	.db #0xda	; 218
	.db #0x3a	; 58
	.db #0xba	; 186
	.db #0x7a	; 122	'z'
	.db #0xfa	; 250
	.db #0x06	; 6
	.db #0x86	; 134
	.db #0x46	; 70	'F'
	.db #0xc6	; 198
	.db #0x26	; 38
	.db #0xa6	; 166
	.db #0x66	; 102	'f'
	.db #0xe6	; 230
	.db #0x16	; 22
	.db #0x96	; 150
	.db #0x56	; 86	'V'
	.db #0xd6	; 214
	.db #0x36	; 54	'6'
	.db #0xb6	; 182
	.db #0x76	; 118	'v'
	.db #0xf6	; 246
	.db #0x0e	; 14
	.db #0x8e	; 142
	.db #0x4e	; 78	'N'
	.db #0xce	; 206
	.db #0x2e	; 46
	.db #0xae	; 174
	.db #0x6e	; 110	'n'
	.db #0xee	; 238
	.db #0x1e	; 30
	.db #0x9e	; 158
	.db #0x5e	; 94
	.db #0xde	; 222
	.db #0x3e	; 62
	.db #0xbe	; 190
	.db #0x7e	; 126
	.db #0xfe	; 254
	.db #0x01	; 1
	.db #0x81	; 129
	.db #0x41	; 65	'A'
	.db #0xc1	; 193
	.db #0x21	; 33
	.db #0xa1	; 161
	.db #0x61	; 97	'a'
	.db #0xe1	; 225
	.db #0x11	; 17
	.db #0x91	; 145
	.db #0x51	; 81	'Q'
	.db #0xd1	; 209
	.db #0x31	; 49	'1'
	.db #0xb1	; 177
	.db #0x71	; 113	'q'
	.db #0xf1	; 241
	.db #0x09	; 9
	.db #0x89	; 137
	.db #0x49	; 73	'I'
	.db #0xc9	; 201
	.db #0x29	; 41
	.db #0xa9	; 169
	.db #0x69	; 105	'i'
	.db #0xe9	; 233
	.db #0x19	; 25
	.db #0x99	; 153
	.db #0x59	; 89	'Y'
	.db #0xd9	; 217
	.db #0x39	; 57	'9'
	.db #0xb9	; 185
	.db #0x79	; 121	'y'
	.db #0xf9	; 249
	.db #0x05	; 5
	.db #0x85	; 133
	.db #0x45	; 69	'E'
	.db #0xc5	; 197
	.db #0x25	; 37
	.db #0xa5	; 165
	.db #0x65	; 101	'e'
	.db #0xe5	; 229
	.db #0x15	; 21
	.db #0x95	; 149
	.db #0x55	; 85	'U'
	.db #0xd5	; 213
	.db #0x35	; 53	'5'
	.db #0xb5	; 181
	.db #0x75	; 117	'u'
	.db #0xf5	; 245
	.db #0x0d	; 13
	.db #0x8d	; 141
	.db #0x4d	; 77	'M'
	.db #0xcd	; 205
	.db #0x2d	; 45
	.db #0xad	; 173
	.db #0x6d	; 109	'm'
	.db #0xed	; 237
	.db #0x1d	; 29
	.db #0x9d	; 157
	.db #0x5d	; 93
	.db #0xdd	; 221
	.db #0x3d	; 61
	.db #0xbd	; 189
	.db #0x7d	; 125
	.db #0xfd	; 253
	.db #0x03	; 3
	.db #0x83	; 131
	.db #0x43	; 67	'C'
	.db #0xc3	; 195
	.db #0x23	; 35
	.db #0xa3	; 163
	.db #0x63	; 99	'c'
	.db #0xe3	; 227
	.db #0x13	; 19
	.db #0x93	; 147
	.db #0x53	; 83	'S'
	.db #0xd3	; 211
	.db #0x33	; 51	'3'
	.db #0xb3	; 179
	.db #0x73	; 115	's'
	.db #0xf3	; 243
	.db #0x0b	; 11
	.db #0x8b	; 139
	.db #0x4b	; 75	'K'
	.db #0xcb	; 203
	.db #0x2b	; 43
	.db #0xab	; 171
	.db #0x6b	; 107	'k'
	.db #0xeb	; 235
	.db #0x1b	; 27
	.db #0x9b	; 155
	.db #0x5b	; 91
	.db #0xdb	; 219
	.db #0x3b	; 59
	.db #0xbb	; 187
	.db #0x7b	; 123
	.db #0xfb	; 251
	.db #0x07	; 7
	.db #0x87	; 135
	.db #0x47	; 71	'G'
	.db #0xc7	; 199
	.db #0x27	; 39
	.db #0xa7	; 167
	.db #0x67	; 103	'g'
	.db #0xe7	; 231
	.db #0x17	; 23
	.db #0x97	; 151
	.db #0x57	; 87	'W'
	.db #0xd7	; 215
	.db #0x37	; 55	'7'
	.db #0xb7	; 183
	.db #0x77	; 119	'w'
	.db #0xf7	; 247
	.db #0x0f	; 15
	.db #0x8f	; 143
	.db #0x4f	; 79	'O'
	.db #0xcf	; 207
	.db #0x2f	; 47
	.db #0xaf	; 175
	.db #0x6f	; 111	'o'
	.db #0xef	; 239
	.db #0x1f	; 31
	.db #0x9f	; 159
	.db #0x5f	; 95
	.db #0xdf	; 223
	.db #0x3f	; 63
	.db #0xbf	; 191
	.db #0x7f	; 127
	.db #0xff	; 255
;src/metasprites.c:106: uint8_t get_tile_offset(uint8_t flipx, uint8_t flipy)
;	---------------------------------
; Function get_tile_offset
; ---------------------------------
_get_tile_offset::
;src/metasprites.c:117: return offset;
	xor	a, a
;src/metasprites.c:118: }
	ret
;src/metasprites.c:123: void load_and_duplicate_sprite_tile_data(void)
;	---------------------------------
; Function load_and_duplicate_sprite_tile_data
; ---------------------------------
_load_and_duplicate_sprite_tile_data::
;src/metasprites.c:126: num_tiles = sizeof(sprite_tiles) >> 4;
	ld	hl, #_num_tiles
	ld	a, #0x30
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
;src/metasprites.c:127: for(i = 0; i < num_tiles; i++)
	ld	bc, #0x0000
00103$:
	ld	hl, #_num_tiles
	ld	a, c
	sub	a, (hl)
	inc	hl
	ld	a, b
	sbc	a, (hl)
	ret	NC
;src/metasprites.c:129: set_tile(i + get_tile_offset(0, 0), sprite_tiles + (i << 4), 0, 0);
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de, #_sprite_tiles
	add	hl, de
	ld	e, l
	ld	d, h
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	push	bc
	push	de
	xor	a, a
	ld	e, a
	call	_get_tile_offset
	pop	de
	pop	bc
	pop	hl
	add	a, l
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	bc
	xor	a, a
	rrca
	push	af
	ld	a, l
	call	_set_tile
	pop	bc
;src/metasprites.c:127: for(i = 0; i < num_tiles; i++)
	inc	bc
;src/metasprites.c:140: }
	jr	00103$
;src/metasprites.c:160: void main(void) {
;	---------------------------------
; Function main
; ---------------------------------
_main::
	add	sp, #-6
;src/metasprites.c:161: DISPLAY_OFF;
	call	_display_off
;src/metasprites.c:164: cgb_compatibility();
	call	_cgb_compatibility
;src/metasprites.c:165: set_sprite_palette(OAMF_CGB_PAL0, 1, gray_pal);
	ld	de, #_gray_pal
	push	de
	xor	a, a
	inc	a
	push	af
	call	_set_sprite_palette
	add	sp, #4
;src/metasprites.c:166: set_sprite_palette(OAMF_CGB_PAL1, 1, pink_pal);
	ld	de, #_pink_pal
	push	de
	ld	hl, #0x101
	push	hl
	call	_set_sprite_palette
	add	sp, #4
;src/metasprites.c:167: set_sprite_palette(OAMF_CGB_PAL2, 1, cyan_pal);
	ld	de, #_cyan_pal
	push	de
	ld	hl, #0x102
	push	hl
	call	_set_sprite_palette
	add	sp, #4
;src/metasprites.c:168: set_sprite_palette(OAMF_CGB_PAL3, 1, green_pal);
	ld	de, #_green_pal
	push	de
	ld	hl, #0x103
	push	hl
	call	_set_sprite_palette
	add	sp, #4
;src/metasprites.c:177: fill_bkg_rect(0, 0, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT, 0);
	xor	a, a
	ld	h, a
	ld	l, #0x12
	push	hl
	ld	a, #0x14
	push	af
	inc	sp
	xor	a, a
	rrca
	push	af
	call	_fill_bkg_rect
	add	sp, #5
;src/metasprites.c:180: set_bkg_data(0, 1, pattern);
	ld	de, #_pattern
	push	de
	xor	a, a
	inc	a
	push	af
	call	_set_bkg_data
	add	sp, #4
;src/metasprites.c:183: load_and_duplicate_sprite_tile_data();
	call	_load_and_duplicate_sprite_tile_data
;src/metasprites.c:186: SHOW_BKG; SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;src/metasprites.c:192: SPRITES_8x8;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfb
	ldh	(_LCDC_REG + 0), a
;src/metasprites.c:194: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;src/metasprites.c:197: PosX = (DEVICE_SCREEN_PX_WIDTH / 2) << 4;
	ld	hl, #_PosX
	xor	a, a
	ld	(hl+), a
	ld	(hl), #0x05
;src/metasprites.c:198: PosY = (DEVICE_SCREEN_PX_HEIGHT / 2) << 4;
	ld	hl, #_PosY
	ld	a, #0x80
	ld	(hl+), a
	ld	(hl), #0x04
;src/metasprites.c:199: SpdX = SpdY = 0;
	xor	a, a
	ld	hl, #_SpdY
	ld	(hl+), a
	ld	(hl), a
	xor	a, a
	ld	hl, #_SpdX
	ld	(hl+), a
	ld	(hl), a
;src/metasprites.c:201: idx = 0; rot = 0;
	ld	hl, #_idx
	ld	(hl), #0x00
	ld	hl, #_rot
	ld	(hl), #0x00
;src/metasprites.c:203: while(TRUE) {        
00145$:
;src/metasprites.c:205: KEY_INPUT;
	ld	a, (#_joyp)
	ld	(#_old_joyp),a
	call	_joypad
	ld	(#_joyp),a
;src/metasprites.c:207: PosF = 0;
	ld	hl, #_PosF
	ld	(hl), #0x00
;src/metasprites.c:209: if (KEY_DOWN(J_UP)) {
	ld	a, (#_joyp)
	ldhl	sp,	#4
	ld	(hl), a
;src/metasprites.c:210: SpdY -= 2;
	ld	hl, #_SpdY
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
;src/metasprites.c:212: PosF |= ACC_Y;
	ld	a, (#_PosF)
	or	a, #0x02
	ldhl	sp,	#5
	ld	(hl), a
;src/metasprites.c:209: if (KEY_DOWN(J_UP)) {
	push	hl
	dec	hl
	bit	2, (hl)
	pop	hl
	jr	Z, 00108$
;src/metasprites.c:210: SpdY -= 2;
	dec	bc
	dec	bc
	ld	hl, #_SpdY
	ld	a, c
	ld	(hl+), a
;src/metasprites.c:211: if (SpdY < -32) SpdY = -32;
	ld	a, b
	ld	(hl-), a
	ld	a, (hl+)
	sub	a, #0xe0
	ld	a, (hl)
	sbc	a, #0xff
	ld	d, (hl)
	ld	a, #0xff
	bit	7,a
	jr	Z, 00319$
	bit	7, d
	jr	NZ, 00320$
	cp	a, a
	jr	00320$
00319$:
	bit	7, d
	jr	Z, 00320$
	scf
00320$:
	jr	NC, 00102$
	ld	hl, #_SpdY
	ld	a, #0xe0
	ld	(hl+), a
	ld	(hl), #0xff
00102$:
;src/metasprites.c:212: PosF |= ACC_Y;
	ldhl	sp,	#5
	ld	a, (hl)
	ld	(#_PosF),a
	jr	00109$
00108$:
;src/metasprites.c:213: } else if (KEY_DOWN(J_DOWN)) {
	push	hl
	ldhl	sp,	#6
	bit	3, (hl)
	pop	hl
	jr	Z, 00109$
;src/metasprites.c:214: SpdY += 2;
	inc	bc
	inc	bc
	ld	hl, #_SpdY
	ld	a, c
	ld	(hl+), a
;src/metasprites.c:215: if (SpdY > 32) SpdY = 32;
	ld	a, b
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	e, b
	ld	d, #0x00
	ld	a, #0x20
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	bit	7, e
	jr	Z, 00322$
	bit	7, d
	jr	NZ, 00323$
	cp	a, a
	jr	00323$
00322$:
	bit	7, d
	jr	Z, 00323$
	scf
00323$:
	jr	NC, 00104$
	ld	hl, #_SpdY
	ld	a, #0x20
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
00104$:
;src/metasprites.c:216: PosF |= ACC_Y;
	ldhl	sp,	#5
	ld	a, (hl)
	ld	(#_PosF),a
00109$:
;src/metasprites.c:220: SpdX -= 2;
	ld	hl, #_SpdX
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
;src/metasprites.c:222: PosF |= ACC_X;
	ld	a, (#_PosF)
	or	a, #0x01
	ldhl	sp,	#5
	ld	(hl), a
;src/metasprites.c:219: if (KEY_DOWN(J_LEFT)) {
	push	hl
	dec	hl
	bit	1, (hl)
	pop	hl
	jr	Z, 00117$
;src/metasprites.c:220: SpdX -= 2;
	dec	de
	dec	de
	ld	hl, #_SpdX
	ld	a, e
	ld	(hl+), a
;src/metasprites.c:221: if (SpdX < -32) SpdX = -32;
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	sub	a, #0xe0
	ld	a, (hl)
	sbc	a, #0xff
	ld	d, (hl)
	ld	a, #0xff
	bit	7,a
	jr	Z, 00325$
	bit	7, d
	jr	NZ, 00326$
	cp	a, a
	jr	00326$
00325$:
	bit	7, d
	jr	Z, 00326$
	scf
00326$:
	jr	NC, 00111$
	ld	hl, #_SpdX
	ld	a, #0xe0
	ld	(hl+), a
	ld	(hl), #0xff
00111$:
;src/metasprites.c:222: PosF |= ACC_X;
	ldhl	sp,	#5
	ld	a, (hl)
	ld	(#_PosF),a
	jr	00118$
00117$:
;src/metasprites.c:223: } else if (KEY_DOWN(J_RIGHT)) {
	push	hl
	ldhl	sp,	#6
	bit	0, (hl)
	pop	hl
	jr	Z, 00118$
;src/metasprites.c:224: SpdX += 2;
	inc	de
	inc	de
	ld	hl, #_SpdX
	ld	a, e
	ld	(hl+), a
;src/metasprites.c:225: if (SpdX > 32) SpdX = 32;
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	e, b
	ld	d, #0x00
	ld	a, #0x20
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	bit	7, e
	jr	Z, 00328$
	bit	7, d
	jr	NZ, 00329$
	cp	a, a
	jr	00329$
00328$:
	bit	7, d
	jr	Z, 00329$
	scf
00329$:
	jr	NC, 00113$
	ld	hl, #_SpdX
	ld	a, #0x20
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
00113$:
;src/metasprites.c:226: PosF |= ACC_X;
	ldhl	sp,	#5
	ld	a, (hl)
	ld	(#_PosF),a
00118$:
;src/metasprites.c:230: if (KEY_PRESSED(J_B)) {
	ld	a, (#_joyp)
	ld	hl, #_old_joyp
	xor	a, (hl)
	ld	hl, #_joyp
	and	a, (hl)
	ld	c, a
	bit	5, c
	jr	Z, 00122$
;src/metasprites.c:231: idx++; if (idx >= (sizeof(sprite_metasprites) >> 1)) idx = 0;
	ld	hl, #_idx
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jr	C, 00122$
	ld	(hl), #0x00
00122$:
;src/metasprites.c:235: if (KEY_PRESSED(J_A)) {
	bit	4, c
	jr	Z, 00124$
;src/metasprites.c:236: rot++; rot &= 0xF;
	ld	hl, #_rot
	inc	(hl)
	ld	a, (hl)
	and	a, #0x0f
	ld	(hl), a
00124$:
;src/metasprites.c:239: PosX += SpdX, PosY += SpdY; 
	ld	a, (#_PosX)
	ld	hl, #_SpdX
	add	a, (hl)
	ld	hl, #_PosX
	ld	(hl+), a
	ld	a, (hl)
	ld	hl, #_SpdX + 1
	adc	a, (hl)
	ld	(#_PosX + 1),a
	ld	a, (#_PosY)
	ld	hl, #_SpdY
	add	a, (hl)
	ld	hl, #_PosY
	ld	(hl+), a
	ld	a, (hl)
	ld	hl, #_SpdY + 1
	adc	a, (hl)
	ld	(#_PosY + 1),a
;src/metasprites.c:250: uint8_t subpal = rot >> 2;
	ld	a, (#_rot)
	rrca
	rrca
	and	a, #0x3f
	ldhl	sp,	#5
	ld	(hl), a
;src/metasprites.c:251: switch (rot & 0x3) {
	ld	a, (#_rot)
	and	a, #0x03
	ldhl	sp,	#2
	ld	(hl), a
;src/metasprites.c:258: DEVICE_SPRITE_PX_OFFSET_Y + (PosY >> 4));
	ld	hl, #_PosY
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	sra	d
	rr	e
	sra	d
	rr	e
	sra	d
	rr	e
	sra	d
	rr	e
;src/metasprites.c:257: DEVICE_SPRITE_PX_OFFSET_X + (PosX >> 4),
	ld	hl, #_PosX
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
;src/metasprites.c:258: DEVICE_SPRITE_PX_OFFSET_Y + (PosY >> 4));
	ld	a, e
;src/metasprites.c:257: DEVICE_SPRITE_PX_OFFSET_X + (PosX >> 4),
;src/metasprites.c:258: DEVICE_SPRITE_PX_OFFSET_Y + (PosY >> 4));
	add	a, #0x10
	ldhl	sp,	#3
;src/metasprites.c:257: DEVICE_SPRITE_PX_OFFSET_X + (PosX >> 4),
	ld	(hl+), a
	ld	a, c
	add	a, #0x08
;src/metasprites.c:251: switch (rot & 0x3) {
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	dec	a
	jr	Z, 00125$
	ldhl	sp,	#2
	ld	a, (hl)
	sub	a, #0x02
	jr	Z, 00126$
	ldhl	sp,	#2
	ld	a, (hl)
	sub	a, #0x03
	jp	Z,00127$
	jp	00128$
;src/metasprites.c:252: case 1:
00125$:
;src/metasprites.c:258: DEVICE_SPRITE_PX_OFFSET_Y + (PosY >> 4));
;src/metasprites.c:257: DEVICE_SPRITE_PX_OFFSET_X + (PosX >> 4),
;src/metasprites.c:254: TILE_NUM_START + get_tile_offset(0, 1),
	ld	e, #0x01
	xor	a, a
	call	_get_tile_offset
	ld	c, a
;src/metasprites.c:253: hiwater += move_metasprite_flipy( sprite_metasprites[idx],
	ld	de, #_sprite_metasprites+0
	ld	hl, #_idx
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, de
	ld	a, (hl+)
	ld	b, (hl)
;src/metasprites.c:258: DEVICE_SPRITE_PX_OFFSET_Y + (PosY >> 4));
	ldhl	sp,	#4
	ld	e, (hl)
;c:\development\repositories\personal\dadish-gbc\build\gbdk-2020\include\gb\metasprites.h:241: __current_metasprite = metasprite;
	ld	hl, #___current_metasprite
	ld	(hl+), a
	ld	(hl), b
;c:\development\repositories\personal\dadish-gbc\build\gbdk-2020\include\gb\metasprites.h:242: __current_base_tile = base_tile;
	ld	hl, #___current_base_tile
	ld	(hl), c
;c:\development\repositories\personal\dadish-gbc\build\gbdk-2020\include\gb\metasprites.h:243: __current_base_prop = base_prop;
	ldhl	sp,	#5
	ld	a, (hl)
	ld	(#___current_base_prop),a
;c:\development\repositories\personal\dadish-gbc\build\gbdk-2020\include\gb\metasprites.h:244: return __move_metasprite_flipy(base_sprite, ((y - ((LCDC_REG & LCDCF_OBJ16) ? 16u : 8u)) << 8) | x);
	ldhl	sp,	#3
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ldh	a, (_LCDC_REG + 0)
	bit	2, a
	jr	Z, 00153$
	ld	bc, #0x0010
	jr	00154$
00153$:
	ld	bc, #0x0008
00154$:
;	spillPairReg hl
;	spillPairReg hl
	ld	a, l
	sub	a, c
	ld	d, a
	xor	a, a
	call	___move_metasprite_flipy
;src/metasprites.c:258: DEVICE_SPRITE_PX_OFFSET_Y + (PosY >> 4));
	ldhl	sp,	#5
	ld	(hl), a
;src/metasprites.c:259: break;
	jp	00129$
;src/metasprites.c:260: case 2:
00126$:
;src/metasprites.c:266: DEVICE_SPRITE_PX_OFFSET_Y + (PosY >> 4));
;src/metasprites.c:265: DEVICE_SPRITE_PX_OFFSET_X + (PosX >> 4),
;src/metasprites.c:262: TILE_NUM_START + get_tile_offset(1, 1),
	ld	a,#0x01
	ld	e,a
	call	_get_tile_offset
	ld	c, a
;src/metasprites.c:261: hiwater += move_metasprite_flipxy(sprite_metasprites[idx],
	ld	de, #_sprite_metasprites+0
	ld	hl, #_idx
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, de
	ld	a, (hl+)
	ld	b, (hl)
;src/metasprites.c:266: DEVICE_SPRITE_PX_OFFSET_Y + (PosY >> 4));
	ldhl	sp,	#4
	ld	e, (hl)
;c:\development\repositories\personal\dadish-gbc\build\gbdk-2020\include\gb\metasprites.h:281: __current_metasprite = metasprite;
	ld	hl, #___current_metasprite
	ld	(hl+), a
	ld	(hl), b
;c:\development\repositories\personal\dadish-gbc\build\gbdk-2020\include\gb\metasprites.h:282: __current_base_tile = base_tile;
	ld	hl, #___current_base_tile
	ld	(hl), c
;c:\development\repositories\personal\dadish-gbc\build\gbdk-2020\include\gb\metasprites.h:283: __current_base_prop = base_prop;
	ldhl	sp,	#5
	ld	a, (hl)
	ld	(#___current_base_prop),a
;c:\development\repositories\personal\dadish-gbc\build\gbdk-2020\include\gb\metasprites.h:284: return __move_metasprite_flipxy(base_sprite, ((y - ((LCDC_REG & LCDCF_OBJ16) ? 16u : 8u)) << 8) | (uint8_t)(x - 8));
	ldhl	sp,	#3
	ld	d, (hl)
	ldh	a, (_LCDC_REG + 0)
	bit	2, a
	jr	Z, 00155$
	ld	bc, #0x0010
	jr	00156$
00155$:
	ld	bc, #0x0008
00156$:
	ld	a, d
	sub	a, c
	ld	b, a
	ld	a, e
	add	a, #0xf8
	ld	e, a
	ld	d, b
	xor	a, a
	call	___move_metasprite_flipxy
;src/metasprites.c:266: DEVICE_SPRITE_PX_OFFSET_Y + (PosY >> 4));
	ldhl	sp,	#5
	ld	(hl), a
;src/metasprites.c:267: break;
	jp	00129$
;src/metasprites.c:268: case 3:
00127$:
;src/metasprites.c:274: DEVICE_SPRITE_PX_OFFSET_Y + (PosY >> 4));
;src/metasprites.c:273: DEVICE_SPRITE_PX_OFFSET_X + (PosX >> 4),
;src/metasprites.c:270: TILE_NUM_START + get_tile_offset(1, 0),
	ld	e, #0x00
	ld	a, #0x01
	call	_get_tile_offset
	ld	c, a
;src/metasprites.c:269: hiwater += move_metasprite_flipx( sprite_metasprites[idx],
	ld	hl, #_idx
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	xor	a, a
	ld	h, a
	add	hl, hl
	ld	de, #_sprite_metasprites
	add	hl, de
	ld	a,	(hl+)
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
;	spillPairReg hl
;c:\development\repositories\personal\dadish-gbc\build\gbdk-2020\include\gb\metasprites.h:200: __current_metasprite = metasprite;
	ld	e, a
	ld	d, h
	ld	hl, #___current_metasprite
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;c:\development\repositories\personal\dadish-gbc\build\gbdk-2020\include\gb\metasprites.h:201: __current_base_tile = base_tile;
	ld	hl, #___current_base_tile
	ld	(hl), c
;c:\development\repositories\personal\dadish-gbc\build\gbdk-2020\include\gb\metasprites.h:202: __current_base_prop = base_prop;
	ldhl	sp,	#5
	ld	a, (hl)
	ld	(#___current_base_prop),a
;c:\development\repositories\personal\dadish-gbc\build\gbdk-2020\include\gb\metasprites.h:203: return __move_metasprite_flipx(base_sprite, (y << 8) | (uint8_t)(x - 8u));
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl)
	add	a, #0xf8
	ld	e, a
	ld	d, b
	xor	a, a
	call	___move_metasprite_flipx
	ldhl	sp,	#5
	ld	(hl), a
;src/metasprites.c:275: break;
	jr	00129$
;src/metasprites.c:276: default:
00128$:
;src/metasprites.c:282: DEVICE_SPRITE_PX_OFFSET_Y + (PosY >> 4));
	ldhl	sp,	#3
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
;src/metasprites.c:281: DEVICE_SPRITE_PX_OFFSET_X + (PosX >> 4),
	ldhl	sp,	#4
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	ldhl	sp,	#5
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl), a
;src/metasprites.c:278: TILE_NUM_START + get_tile_offset(0, 0),
	xor	a, a
	ld	e, a
	call	_get_tile_offset
	ldhl	sp,	#3
	ld	(hl), a
;src/metasprites.c:277: hiwater += move_metasprite_ex(    sprite_metasprites[idx],
	ld	hl, #_idx
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	xor	a, a
	ld	h, a
	add	hl, hl
	ld	de, #_sprite_metasprites
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#4
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
;c:\development\repositories\personal\dadish-gbc\build\gbdk-2020\include\gb\metasprites.h:160: __current_metasprite = metasprite;
	ldhl	sp,	#4
	ld	a, (hl)
	ld	(#___current_metasprite),a
	ldhl	sp,	#5
	ld	a, (hl)
	ld	(#___current_metasprite + 1),a
;c:\development\repositories\personal\dadish-gbc\build\gbdk-2020\include\gb\metasprites.h:161: __current_base_tile = base_tile;
	ldhl	sp,	#3
	ld	a, (hl)
	ld	(#___current_base_tile),a
;c:\development\repositories\personal\dadish-gbc\build\gbdk-2020\include\gb\metasprites.h:162: __current_base_prop = base_prop;
	ldhl	sp,	#2
	ld	a, (hl)
	ld	(#___current_base_prop),a
;c:\development\repositories\personal\dadish-gbc\build\gbdk-2020\include\gb\metasprites.h:163: return __move_metasprite(base_sprite, (y << 8) | (uint8_t)x);
	ldhl	sp,	#0
	ld	c, (hl)
	ldhl	sp,	#5
	ld	a, c
	ld	(hl-), a
	ld	(hl), #0x00
	ldhl	sp,	#1
	ld	e, (hl)
	ldhl	sp,	#5
	ld	d, (hl)
	xor	a, a
	call	___move_metasprite
	ldhl	sp,	#5
	ld	(hl), a
;src/metasprites.c:284: }
00129$:
;src/metasprites.c:287: hide_sprites_range(hiwater, MAX_HARDWARE_SPRITES);        
	ld	e, #0x28
	ldhl	sp,	#5
	ld	a, (hl)
	call	_hide_sprites_range
;src/metasprites.c:290: if (!(PosF & ACC_Y)) {
	ld	hl, #_PosF
	ld	c, (hl)
	bit	1, c
	jr	NZ, 00136$
;src/metasprites.c:291: if (SpdY != 0) {
	ld	hl, #_SpdY + 1
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00136$
;src/metasprites.c:292: if (SpdY > 0) SpdY--;
	ld	a, (hl+)
	ld	b, a
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	e, l
	xor	a, a
	ld	d, a
	cp	a, b
	sbc	a, l
	bit	7, e
	jr	Z, 00339$
	bit	7, d
	jr	NZ, 00340$
	cp	a, a
	jr	00340$
00339$:
	bit	7, d
	jr	Z, 00340$
	scf
00340$:
	jr	NC, 00131$
	ld	hl, #_SpdY
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	jr	00136$
00131$:
;src/metasprites.c:293: else SpdY ++;
	ld	hl, #_SpdY
	inc	(hl)
	jr	NZ, 00341$
	inc	hl
	inc	(hl)
00341$:
00136$:
;src/metasprites.c:298: if (!(PosF & ACC_X)) {
	bit	0, c
	jr	NZ, 00143$
;src/metasprites.c:299: if (SpdX != 0) {
	ld	hl, #_SpdX + 1
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00143$
;src/metasprites.c:300: if (SpdX > 0) SpdX--;
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	e, b
	xor	a, a
	ld	d, a
	cp	a, c
	sbc	a, b
	bit	7, e
	jr	Z, 00344$
	bit	7, d
	jr	NZ, 00345$
	cp	a, a
	jr	00345$
00344$:
	bit	7, d
	jr	Z, 00345$
	scf
00345$:
	jr	NC, 00138$
	ld	hl, #_SpdX
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	jr	00143$
00138$:
;src/metasprites.c:301: else SpdX ++;
	ld	hl, #_SpdX
	inc	(hl)
	jr	NZ, 00346$
	inc	hl
	inc	(hl)
00346$:
00143$:
;src/metasprites.c:307: vsync();
	call	_vsync
	jp	00145$
;src/metasprites.c:309: }
	add	sp, #6
	ret
_gray_pal:
	.dw #0x7fff
	.dw #0x56b5
	.dw #0x294a
	.dw #0x0000
_pink_pal:
	.dw #0x7fff
	.dw #0x7c1f
	.dw #0x5415
	.dw #0x280a
_cyan_pal:
	.dw #0x7fff
	.dw #0x7fea
	.dw #0x56a0
	.dw #0x2940
_green_pal:
	.dw #0x7fff
	.dw #0x57f5
	.dw #0x02a0
	.dw #0x0140
	.area _CODE
	.area _INITIALIZER
__xinit__joyp:
	.db #0x00	; 0
__xinit__old_joyp:
	.db #0x00	; 0
	.area _CABS (ABS)
