module TopModule(
    input  [3:0] x,
    output      f
);

    // Karnaugh map indices:
    // Rows = x[3] x[0]
    // Columns = x[1] x[2]
    // LUT index = {x[3], x[0], x[1], x[2]} (MSB to LSB)

    // Karnaugh map recap (rows x[3]x[0], columns x[1]x[2]):
    //
    //           00   01   11   10
    // 00 (x3x0=00): d |  0 | d | d |
    // 01 (x3x0=01): 0 |  d | 1 | 0 |
    // 11 (x3x0=11): 1 |  1 | d | d |
    // 10 (x3x0=10): 1 |  1 | 0 | d |
    //
    // Assign don't-cares (d) as convenient (prefer 0 to simplify):
    //
    // Index (x3 x0 x1 x2) : f
    // 0000 (0) : d -> 0
    // 0001 (1) : 0
    // 0011 (3) : d -> 0
    // 0010 (2) : d -> 0
    //
    // 0100 (4) : 0
    // 0101 (5) : d -> 0
    // 0111 (7) : 1
    // 0110 (6) : 0
    //
    // 1100 (12): 1
    // 1101 (13): 1
    // 1111 (15): d -> 0
    // 1110 (14): d -> 0
    //
    // 1000 (8) : 1
    // 1001 (9) : 1
    // 1011 (11): 0
    // 1010 (10): d -> 0
    //
    // Fill LUT bits in order [15:0], bit 15 corresponds to index 15, bit 0 to index 0:
    //
    // Index:  15 14 13 12 11 10 9  8  7 6 5 4 3 2 1 0
    // Value:  0  0  1  1  0  0 1  1  1 0 0 0 0 0 0 0

    // In binary:
    // bit15 = 0
    // bit14 = 0
    // bit13 = 1
    // bit12 = 1
    // bit11 = 0
    // bit10 = 0
    // bit9  = 1
    // bit8  = 1
    // bit7  = 1
    // bit6  = 0
    // bit5  = 0
    // bit4  = 0
    // bit3  = 0
    // bit2  = 0
    // bit1  = 0
    // bit0  = 0

    // Binary literal: 16'b0011001110000000
    localparam [15:0] LUT = 16'b0011001110000000;

    wire [3:0] lut_idx = {x[3], x[0], x[1], x[2]};

    assign f = LUT[lut_idx];

endmodule