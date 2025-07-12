module TopModule (
    input  [3:0] x,  // x = {x4, x3, x2, x1}
    output      f
);

    // Direct mapping of input bits to Karnaugh map row and column indices:
    // row = {x4, x3}, column = {x2, x1}
    // Use 4-bit index: {row, column} = x[3:0]

    // Assign output f according to the Karnaugh map with don't cares as 0:
    // Using binary indexing directly from x[3:0]:
    //
    // Index (row col)  | Value (f)
    // 0000 (00 00)     | d->0
    // 0001 (00 01)     | 0
    // 0010 (00 10)     | d->0
    // 0011 (00 11)     | d->0
    //
    // 0100 (01 00)     | 0
    // 0101 (01 01)     | d->0
    // 0110 (01 10)     | 1
    // 0111 (01 11)     | 0
    //
    // 1000 (10 00)     | 1
    // 1001 (10 01)     | 1
    // 1010 (10 10)     | 0
    // 1011 (10 11)     | d->0
    //
    // 1100 (11 00)     | 1
    // 1101 (11 01)     | 1
    // 1110 (11 10)     | d->0
    // 1111 (11 11)     | d->0

    // Define a 16-entry ROM using a 16-bit constant for all input combinations
    // where bit position equals the 4-bit input x:
    // Bits: f = 16'b... [x3x2x1x0 indexing from MSB to LSB]
    // Let's list bits from 15 downto 0 = inputs 1111 down to 0000:
    // 1111 (15): 0
    // 1110 (14): 0
    // 1101 (13): 1
    // 1100 (12): 1
    // 1011 (11): 0
    // 1010 (10): 0
    // 1001 (9):  1
    // 1000 (8):  1
    // 0111 (7):  0
    // 0110 (6):  1
    // 0101 (5):  0
    // 0100 (4):  0
    // 0011 (3):  0
    // 0010 (2):  0
    // 0001 (1):  0
    // 0000 (0):  0

    // Assign bit 0 = f for input 0000 (x=0), bit 15 = f for input 1111 (x=15)

    // Bit vector from bit15 to bit0: 0 0 1 1 0 0 1 1 0 1 0 0 0 0 0 0
    // Binary: 16'b0011001101000000
    // Let's verify: bit 13 = 1 (1101): ok
    // bit 12 = 1 (1100): ok
    // bit 9 = 1 (1001): ok
    // bit 8 = 1 (1000): ok
    // bit 6 = 1 (0110): ok
    // others zero as assigned

    wire [15:0] lookup = 16'b0011001101000000;

    assign f = lookup[x];

endmodule