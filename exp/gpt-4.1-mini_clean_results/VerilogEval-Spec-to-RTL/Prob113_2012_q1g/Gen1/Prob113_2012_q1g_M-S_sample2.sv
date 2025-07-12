module TopModule(
    input  [3:0] x,
    output f
);

    // Create a 16-bit constant representing f for all input combinations.
    // Index format: {row, column} = {x[3], x[2], x[1], x[0]}
    // Given the Karnaugh map, we reorder bits accordingly:
    // row = x[2]x[3], column = x[0]x[1], so index = {x[2], x[3], x[0], x[1]}
    // But indexing into a 16-bit vector needs a 4-bit index. To align with the map,
    // we form index as {x[2], x[3], x[0], x[1]}.
    // We'll define the 16-bit constant f_table accordingly, where bit 0 corresponds to index 0.
    // The constant bits are arranged as f_table[{x[2], x[3], x[0], x[1]}].
    
    // Re-express the Karnaugh map as a vector f_table:
    // For all 16 input combinations of (x[3], x[2], x[1], x[0]), we want to find f.
    // Since indexing uses {x[2], x[3], x[0], x[1]}, we convert each input to that index.
    // But to simplify, we can directly evaluate f by rearranging bits accordingly.

    wire [3:0] row = {x[2], x[3]};
    wire [3:0] col = {x[0], x[1]};
    
    // The function f for (row, col) can be mapped by a 16-bit constant:
    // Using the Karnaugh map rows in order 00,01,11,10 and columns 00,01,11,10, the bits can be assigned as:
    // Index = {row, col} = {x[2], x[3], x[0], x[1]} (4 bits)
    // We'll build f_table with bits from LSB (index=0) to MSB (index=15).
    // Map values from the table:
    // row=00 col=00 (index=0b0000) = 1
    // row=00 col=01 (index=0b0001) = 0
    // row=00 col=11 (index=0b0011) = 0
    // row=00 col=10 (index=0b0010) = 1
    // row=01 col=00 (index=0b0100) = 0
    // row=01 col=01 (index=0b0101) = 0
    // row=01 col=11 (index=0b0111) = 0
    // row=01 col=10 (index=0b0110) = 0
    // row=11 col=00 (index=0b1100) = 1
    // row=11 col=01 (index=0b1101) = 1
    // row=11 col=11 (index=0b1111) = 1
    // row=11 col=10 (index=0b1110) = 0
    // row=10 col=00 (index=0b1000) = 1
    // row=10 col=01 (index=0b1001) = 1
    // row=10 col=11 (index=0b1011) = 0
    // row=10 col=10 (index=0b1010) = 1
    //
    // This gives f_table (bit 0 = index 0) = 16'b
    // bit15(0b1111)=1, bit14(0b1110)=0, bit13(0b1101)=1, bit12(0b1100)=1,
    // bit11(0b1011)=0, bit10(0b1010)=1, bit9(0b1001)=1, bit8(0b1000)=1,
    // bit7(0b0111)=0, bit6(0b0110)=0, bit5(0b0101)=0, bit4(0b0100)=0,
    // bit3(0b0011)=0, bit2(0b0010)=1, bit1(0b0001)=0, bit0(0b0000)=1
    
    wire [15:0] f_table = 16'b1110_11011_0000_101;

    wire [3:0] index = {x[2], x[3], x[0], x[1]};
    assign f = f_table[index];

endmodule