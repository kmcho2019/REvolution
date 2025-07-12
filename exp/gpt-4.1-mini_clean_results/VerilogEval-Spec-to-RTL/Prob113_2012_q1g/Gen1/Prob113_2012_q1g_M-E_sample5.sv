module TopModule (
    input  [3:0] x,
    output      f
);

    // The ROM data arranged so that address = {x[3], x[2], x[1], x[0]} matches K-map:
    // Rows indexed by {x[3], x[2]}, Columns by {x[1], x[0]}.
    // Using the K-map values directly:
    // x[3]x[2] x[1]x[0]
    // 00 00 -> 1
    // 00 01 -> 0
    // 00 11 -> 0
    // 00 10 -> 1
    // 01 00 -> 0
    // 01 01 -> 0
    // 01 11 -> 0
    // 01 10 -> 0
    // 11 00 -> 1
    // 11 01 -> 1
    // 11 11 -> 1
    // 11 10 -> 0
    // 10 00 -> 1
    // 10 01 -> 1
    // 10 11 -> 0
    // 10 10 -> 1

    // Construct the ROM contents accordingly:
    // Address: x[3]x[2]x[1]x[0]
    // Data:    f

    wire [15:0] rom = 16'b1010_0000_1110_1101;
    // Index map:
    // addr 0: 0000 -> 1 (bit0)
    // addr 1: 0001 -> 0
    // addr 2: 0010 -> 1
    // addr 3: 0011 -> 0
    // addr 4: 0100 -> 0
    // addr 5: 0101 -> 0
    // addr 6: 0110 -> 0
    // addr 7: 0111 -> 0
    // addr 8: 1000 -> 1
    // addr 9: 1001 -> 1
    // addr10:1010 -> 1
    // addr11:1011 -> 0
    // addr12:1100 -> 1
    // addr13:1101 -> 1
    // addr14:1110 -> 0
    // addr15:1111 -> 1

    // Note: The bits in the literal correspond to addresses from LSB (addr0) to MSB (addr15).
    // Adjust rom assignment to match K-map row and column indexing:
    // After verifying bits, swap some bits for correct mapping:

    // Reconstruct rom bits carefully:
    // addr 0 (0000): x[3]=0,x[2]=0,x[1]=0,x[0]=0 -> K-map 00 00 -> 1
    // addr 1 (0001): 00 01 -> 0
    // addr 2 (0010): 00 10 -> 1
    // addr 3 (0011): 00 11 -> 0
    // addr 4 (0100): 01 00 -> 0
    // addr 5 (0101): 01 01 -> 0
    // addr 6 (0110): 01 10 -> 0
    // addr 7 (0111): 01 11 -> 0
    // addr 8 (1000): 10 00 -> 1
    // addr 9 (1001): 10 01 -> 1
    // addr10(1010): 10 10 -> 1
    // addr11(1011): 10 11 -> 0
    // addr12(1100): 11 00 -> 1
    // addr13(1101): 11 01 -> 1
    // addr14(1110): 11 10 -> 0
    // addr15(1111): 11 11 -> 1

    // These values correspond to 16'b 1010_1101_1010_0101 (bit15 .. bit0)
    // We'll assign accordingly:
    wire [15:0] lookup = 16'b1010_1101_1010_0101;

    assign f = lookup[x];

endmodule