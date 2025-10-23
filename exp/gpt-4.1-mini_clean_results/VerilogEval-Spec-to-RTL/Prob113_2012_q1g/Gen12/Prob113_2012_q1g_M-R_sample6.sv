module TopModule(
    input  [3:0] x,
    output f
);
    // The Karnaugh map is indexed by row = {x[2], x[3]} and col = {x[0], x[1]}
    // Given the input x = {x[3], x[2], x[1], x[0]}, we calculate the index into a LUT
    // The index used in the LUT is: {x[3], x[2], x[1], x[0]} == x directly

    // Build the LUT from the K-map cells:
    // For each possible 4-bit input x[3:0], determine f from the K-map
    
    // K-map (rows = x[2]x[3], columns = x[0]x[1]):
    // Indexing in binary for each input (MSB x[3], LSB x[0]):
    // Inputs and outputs:
    // x[3]x[2]x[1]x[0]  f
    // 0000 (row00 col00) -> 1
    // 0001 (row00 col01) -> 0
    // 0011 (row00 col11) -> 0
    // 0010 (row00 col10) -> 1
    // 0100 (row01 col00) -> 0
    // 0101 (row01 col01) -> 0
    // 0111 (row01 col11) -> 0
    // 0110 (row01 col10) -> 0
    // 1100 (row11 col00) -> 1
    // 1101 (row11 col01) -> 1
    // 1111 (row11 col11) -> 1
    // 1110 (row11 col10) -> 0
    // 1000 (row10 col00) -> 1
    // 1001 (row10 col01) -> 1
    // 1011 (row10 col11) -> 0
    // 1010 (row10 col10) -> 1

    // Build LUT as bits indexed by x from 0 to 15 (x[3:0]):
    // Bit 0 (0000): 1
    // Bit 1 (0001): 0
    // Bit 2 (0010): 1
    // Bit 3 (0011): 0
    // Bit 4 (0100): 0
    // Bit 5 (0101): 0
    // Bit 6 (0110): 0
    // Bit 7 (0111): 0
    // Bit 8 (1000): 1
    // Bit 9 (1001): 1
    // Bit 10(1010):1
    // Bit 11(1011):0
    // Bit 12(1100):1
    // Bit 13(1101):1
    // Bit 14(1110):0
    // Bit 15(1111):1

    wire [15:0] lut = 16'b1010000011101101; // bit0=LSB
    
    assign f = lut[x];

endmodule