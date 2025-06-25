// This examples demonstrates the following features in GBDK's metasprite support.
//
// * Drawing a metasprite with optional X/Y flipping using hardware flipping
// * Drawing a metasprite with optional X/Y flipping using duplicated tiles
// * Drawing a metasprite with different sub-palettes
//
// The flipping of tiles is handled by setting X/Y flip bits on those targets that
// support it in hardware.
//
// For targets that don't have hardware support for flipping, a fallback is provided by
// uploading duplicate tiles flipped in X and Y, and using the base_tile parameter of 
// move_metasprite_* to draw the flipped tiles.
// 
// For targets that support sprite sub-palettes (GBC and NES), the base_props parameter
// of move_metasprite_* is used to switch between 4 different sub-palettes.
// Note that SMS and GG do NOT support sub-palettes for sprites, and this example
// will display the same colors when built for these targets.

#include <stdint.h>

#include <gbdk/platform.h>
#include <gbdk/metasprites.h>

#include <Resources/sprite.h>

#define TILE_WIDTH 8
#define TILE_HEIGHT 8

#define NUMBER_OF_BYTES_PER_TILE 16

#define X_MOVEMENT_ON_THIS_FRAME 1
#define Y_MOVEMENT_ON_THIS_FRAME 2

#define METASPRITE_OAM_START_INDEX 0
#define METASPRITE_TILE_VRAM_OFFSET 0

const uint8_t background_tile_graphics_data[] = {
    0b10000000, 0b10000000,
    0b01000000, 0b01000000,
    0b00100000, 0b00100000,
    0b00010000, 0b00010000,
    0b00001000, 0b00001000,
    0b00000100, 0b00000100,
    0b00000010, 0b00000010,
    0b00000001, 0b00000001
};

int16_t sprite_x_position;
int16_t sprite_y_position;
int16_t sprite_x_velocity;
int16_t sprite_y_velocity;

uint8_t directional_input_flags;
uint8_t current_animation_frame_index;
uint8_t flip_rotation_and_palette_state;

uint8_t tile_transformation_buffer[NUMBER_OF_BYTES_PER_TILE];

size_t total_number_of_sprite_tiles;

uint8_t input_flags_this_frame = 0;
uint8_t input_flags_last_frame = 0;

// TODO: Continue from here down...

#define KEY_INPUT (input_flags_last_frame = input_flags_this_frame, input_flags_this_frame = joypad())
#define KEY_DOWN(KEY) (input_flags_this_frame & (KEY))
#define KEY_PRESSED(KEY) ((input_flags_this_frame ^ input_flags_last_frame) & input_flags_this_frame & (KEY))

// Table for fast reversing of bits in a byte - used for flipping in X
const uint8_t reverse_bits[256] = {
    0x00,0x80,0x40,0xC0,0x20,0xA0,0x60,0xE0,0x10,0x90,0x50,0xD0,0x30,0xB0,0x70,0xF0,
    0x08,0x88,0x48,0xC8,0x28,0xA8,0x68,0xE8,0x18,0x98,0x58,0xD8,0x38,0xB8,0x78,0xF8,
    0x04,0x84,0x44,0xC4,0x24,0xA4,0x64,0xE4,0x14,0x94,0x54,0xD4,0x34,0xB4,0x74,0xF4,
    0x0C,0x8C,0x4C,0xCC,0x2C,0xAC,0x6C,0xEC,0x1C,0x9C,0x5C,0xDC,0x3C,0xBC,0x7C,0xFC,
    0x02,0x82,0x42,0xC2,0x22,0xA2,0x62,0xE2,0x12,0x92,0x52,0xD2,0x32,0xB2,0x72,0xF2,
    0x0A,0x8A,0x4A,0xCA,0x2A,0xAA,0x6A,0xEA,0x1A,0x9A,0x5A,0xDA,0x3A,0xBA,0x7A,0xFA,
    0x06,0x86,0x46,0xC6,0x26,0xA6,0x66,0xE6,0x16,0x96,0x56,0xD6,0x36,0xB6,0x76,0xF6,
    0x0E,0x8E,0x4E,0xCE,0x2E,0xAE,0x6E,0xEE,0x1E,0x9E,0x5E,0xDE,0x3E,0xBE,0x7E,0xFE,
    0x01,0x81,0x41,0xC1,0x21,0xA1,0x61,0xE1,0x11,0x91,0x51,0xD1,0x31,0xB1,0x71,0xF1,
    0x09,0x89,0x49,0xC9,0x29,0xA9,0x69,0xE9,0x19,0x99,0x59,0xD9,0x39,0xB9,0x79,0xF9,
    0x05,0x85,0x45,0xC5,0x25,0xA5,0x65,0xE5,0x15,0x95,0x55,0xD5,0x35,0xB5,0x75,0xF5,
    0x0D,0x8D,0x4D,0xCD,0x2D,0xAD,0x6D,0xED,0x1D,0x9D,0x5D,0xDD,0x3D,0xBD,0x7D,0xFD,
    0x03,0x83,0x43,0xC3,0x23,0xA3,0x63,0xE3,0x13,0x93,0x53,0xD3,0x33,0xB3,0x73,0xF3,
    0x0B,0x8B,0x4B,0xCB,0x2B,0xAB,0x6B,0xEB,0x1B,0x9B,0x5B,0xDB,0x3B,0xBB,0x7B,0xFB,
    0x07,0x87,0x47,0xC7,0x27,0xA7,0x67,0xE7,0x17,0x97,0x57,0xD7,0x37,0xB7,0x77,0xF7,
    0x0F,0x8F,0x4F,0xCF,0x2F,0xAF,0x6F,0xEF,0x1F,0x9F,0x5F,0xDF,0x3F,0xBF,0x7F,0xFF
};

// Helper function to flip tile in X/Y
// Note this assumes 2BPP tile in GB format, where bitplanes are interleaved.
// Currently all platforms use GB format for 2BPP tile data storage, irrespective
// of what their native tile format is, as set_sprite_data handles the conversion.
void set_tile(uint8_t tile_idx, uint8_t* data, uint8_t flip_x, uint8_t flip_y)
{
    size_t i;
    for(i = 0; i < TILE_HEIGHT; i++)
    {
        size_t y = flip_y ? (TILE_HEIGHT-1-i) : i; 
        tile_transformation_buffer[2*i] = flip_x ? reverse_bits[data[2*y]] : data[2*y];
        tile_transformation_buffer[2*i+1] = flip_x ? reverse_bits[data[2*y+1]] : data[2*y+1];
    }
    set_sprite_data(tile_idx, 1, tile_transformation_buffer);
}

uint8_t get_tile_offset(uint8_t flipx, uint8_t flipy)
{
    flipx; flipy; // suppress compiler warnings
    uint8_t offset = 0;
#if !HARDWARE_SPRITE_CAN_FLIP_Y
    offset += flipy ? total_number_of_sprite_tiles : 0;
#endif
#if !HARDWARE_SPRITE_CAN_FLIP_X
    offset <<= 1;
    offset += flipx ? total_number_of_sprite_tiles : 0;
#endif
    return offset;
}

// Load metasprite tile data into VRAM, one tile at a time.
// For each tile, create a duplicate flipped in X and/or Y
// That's placed at tile index = get_tile_offset(flipX?, flipY?)
void load_and_duplicate_sprite_tile_data(void)
{
    size_t i;
    total_number_of_sprite_tiles = sizeof(sprite_tiles) >> 4;
    for(i = 0; i < total_number_of_sprite_tiles; i++)
    {
        set_tile(i + get_tile_offset(0, 0), sprite_tiles + (i << 4), 0, 0);
#if !HARDWARE_SPRITE_CAN_FLIP_X
        set_tile(i + get_tile_offset(1, 0), sprite_tiles + (i << 4), 1, 0);
#endif
#if !HARDWARE_SPRITE_CAN_FLIP_Y
        set_tile(i + get_tile_offset(0, 1), sprite_tiles + (i << 4), 0, 1);
#endif
#if !HARDWARE_SPRITE_CAN_FLIP_X && !HARDWARE_SPRITE_CAN_FLIP_Y
        set_tile(i + get_tile_offset(1, 1), sprite_tiles + (i << 4), 1, 1);
#endif
    }
}

const palette_color_t gray_pal[4] = {   RGB8(255,255,255),
                                        RGB8(170,170,170),
                                        RGB8(85,85,85),
                                        RGB8(0,0,0) };
const palette_color_t pink_pal[4] = {   RGB8(255,255,255),
                                        RGB8(255,0,255),
                                        RGB8(170,0,170),
                                        RGB8(85,0,85) };
const palette_color_t cyan_pal[4] = {   RGB8(255,255,255),
                                        RGB8(85,255,255),
                                        RGB8(0,170,170),
                                        RGB8(0,85,85) };
const palette_color_t green_pal[4] = {  RGB8(255,255,255),
                                        RGB8(170,255,170),
                                        RGB8(0,170,0),
                                        RGB8(0,85,0) };

// Main function
void main(void) {
    DISPLAY_OFF;

#if defined(GAMEBOY)
    cgb_compatibility();
    set_sprite_palette(OAMF_CGB_PAL0, 1, gray_pal);
    set_sprite_palette(OAMF_CGB_PAL1, 1, pink_pal);
    set_sprite_palette(OAMF_CGB_PAL2, 1, cyan_pal);
    set_sprite_palette(OAMF_CGB_PAL3, 1, green_pal);
#elif defined(NINTENDO_NES)
    set_sprite_palette(0, 1, gray_pal);
    set_sprite_palette(1, 1, pink_pal);
    set_sprite_palette(2, 1, cyan_pal);
    set_sprite_palette(3, 1, green_pal);
#endif

    // Fill the screen background with a single tile background_tile_graphics_data
    fill_bkg_rect(0, 0, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT, 0);

    // Set tile data for background
    set_bkg_data(0, 1, background_tile_graphics_data);

    // Load (and flip) sprite tile data
    load_and_duplicate_sprite_tile_data();

    // Show bkg and sprites
    SHOW_BKG; SHOW_SPRITES;

    // Check what size hardware sprite the metasprite is using (from sprite.h)
    #if sprite_TILE_H == 16
        SPRITES_8x16;
    #else
        SPRITES_8x8;
    #endif
    DISPLAY_ON;

    // Set initial position to the center of the screen, zero out speed
    sprite_x_position = (DEVICE_SCREEN_PX_WIDTH / 2) << 4;
    sprite_y_position = (DEVICE_SCREEN_PX_HEIGHT / 2) << 4;
    sprite_x_velocity = sprite_y_velocity = 0;

    current_animation_frame_index = 0; flip_rotation_and_palette_state = 0;

    while(TRUE) {        
        // Poll joypads
        KEY_INPUT;
        
        directional_input_flags = 0;
        // Game object
        if (KEY_DOWN(J_UP)) {
            sprite_y_velocity -= 2;
            if (sprite_y_velocity < -32) sprite_y_velocity = -32;
            directional_input_flags |= Y_MOVEMENT_ON_THIS_FRAME;
        } else if (KEY_DOWN(J_DOWN)) {
            sprite_y_velocity += 2;
            if (sprite_y_velocity > 32) sprite_y_velocity = 32;
            directional_input_flags |= Y_MOVEMENT_ON_THIS_FRAME;
        }

        if (KEY_DOWN(J_LEFT)) {
            sprite_x_velocity -= 2;
            if (sprite_x_velocity < -32) sprite_x_velocity = -32;
            directional_input_flags |= X_MOVEMENT_ON_THIS_FRAME;
        } else if (KEY_DOWN(J_RIGHT)) {
            sprite_x_velocity += 2;
            if (sprite_x_velocity > 32) sprite_x_velocity = 32;
            directional_input_flags |= X_MOVEMENT_ON_THIS_FRAME;
        }

        // Press B button to cycle through metasprite animations
        if (KEY_PRESSED(J_B)) {
            current_animation_frame_index++; if (current_animation_frame_index >= (sizeof(sprite_metasprites) >> 1)) current_animation_frame_index = 0;
        }

        // Press A button to cycle metasprite through Normal/Flip-Y/Flip-XY/Flip-X and sub-pals
        if (KEY_PRESSED(J_A)) {
            flip_rotation_and_palette_state++; flip_rotation_and_palette_state &= 0xF;
        }

        sprite_x_position += sprite_x_velocity, sprite_y_position += sprite_y_velocity; 

        uint8_t hiwater = METASPRITE_OAM_START_INDEX;

        // NOTE: In a real game it would be better to only call the move_metasprite..()
        //       functions if something changed (such as movement or rotation). That
        //       reduces CPU usage on frames that don't need updates.
        //
        // In this example they are called every frame to simplify the example code

        // If not hidden the move and apply rotation to the metasprite
        uint8_t subpal = flip_rotation_and_palette_state >> 2;
        switch (flip_rotation_and_palette_state & 0x3) {
            case 1:
                hiwater += move_metasprite_flipy( sprite_metasprites[current_animation_frame_index],
                                                  METASPRITE_TILE_VRAM_OFFSET + get_tile_offset(0, 1),
                                                  subpal,
                                                  hiwater,
                                                  DEVICE_SPRITE_PX_OFFSET_X + (sprite_x_position >> 4),
                                                  DEVICE_SPRITE_PX_OFFSET_Y + (sprite_y_position >> 4));
                break;
            case 2:
                hiwater += move_metasprite_flipxy(sprite_metasprites[current_animation_frame_index],
                                                  METASPRITE_TILE_VRAM_OFFSET + get_tile_offset(1, 1),
                                                  subpal,
                                                  hiwater,
                                                  DEVICE_SPRITE_PX_OFFSET_X + (sprite_x_position >> 4),
                                                  DEVICE_SPRITE_PX_OFFSET_Y + (sprite_y_position >> 4));
                break;
            case 3:
                hiwater += move_metasprite_flipx( sprite_metasprites[current_animation_frame_index],
                                                  METASPRITE_TILE_VRAM_OFFSET + get_tile_offset(1, 0),
                                                  subpal,
                                                  hiwater,
                                                  DEVICE_SPRITE_PX_OFFSET_X + (sprite_x_position >> 4),
                                                  DEVICE_SPRITE_PX_OFFSET_Y + (sprite_y_position >> 4));
                break;
            default:
                hiwater += move_metasprite_ex(    sprite_metasprites[current_animation_frame_index],
                                                  METASPRITE_TILE_VRAM_OFFSET + get_tile_offset(0, 0),
                                                  subpal,
                                                  hiwater,
                                                  DEVICE_SPRITE_PX_OFFSET_X + (sprite_x_position >> 4),
                                                  DEVICE_SPRITE_PX_OFFSET_Y + (sprite_y_position >> 4));
                break;
        }

        // Hide rest of the hardware sprites, because amount of sprites differ between animation frames.
        hide_sprites_range(hiwater, MAX_HARDWARE_SPRITES);        

        // Y Axis: update velocity (reduce speed) if no U/D button pressed
        if (!(directional_input_flags & Y_MOVEMENT_ON_THIS_FRAME)) {
            if (sprite_y_velocity != 0) {
                if (sprite_y_velocity > 0) sprite_y_velocity--;
                else sprite_y_velocity ++;
            }
        }

        // X Axis: update velocity (reduce speed) if no L/R button pressed
        if (!(directional_input_flags & X_MOVEMENT_ON_THIS_FRAME)) {
            if (sprite_x_velocity != 0) {
                if (sprite_x_velocity > 0) sprite_x_velocity--;
                else sprite_x_velocity ++;
            }
        }

        // Wait for VBlank to slow down everything, and reduce CPU power use on 
        // handheld systems.
        vsync();
    }
}
