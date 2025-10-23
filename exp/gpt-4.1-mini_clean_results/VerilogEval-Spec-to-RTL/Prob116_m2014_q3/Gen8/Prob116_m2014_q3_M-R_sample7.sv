module TopModule(
    input  [3:0] x,
    output      f
);
    // Define the 16-bit function vector where each bit corresponds to f for input x
    // Indexing: bit 0 = f for x=4'b0000, bit 15 = f for x=4'b1111
    // Using the Karnaugh map, 'd' (don't care) entries assigned to 0
    //
    // The order of bits in func_vec corresponds to x interpreted as [3:0] from MSB to LSB
    // with the bit position matching x as integer index.
    //
    // From the Karnaugh map:
    // x (binary) : f
    // 0000: d=0
    // 0001: 0
    // 0010: d=0
    // 0011: d=0
    // 0100: 0
    // 0101: d=0
    // 0110: 0
    // 0111: 1
    // 1000: 1
    // 1001: 1
    // 1010: d=0
    // 1011: 0
    // 1100: 1
    // 1101: 1
    // 1110: d=0
    // 1111: d=0
    //
    // Bit index : f
    //    0: 0
    //    1: 0
    //    2: 0
    //    3: 0
    //    4: 0
    //    5: 0
    //    6: 0
    //    7: 1
    //    8: 1
    //    9: 1
    //   10: 0
    //   11: 0
    //   12: 1
    //   13: 1
    //   14: 0
    //   15: 0
    //
    // Binary: 16'b0000110011000000 reversed for LSB=bit0:
    // Let's write bits from MSB to LSB (bit15..bit0):
    // bit15=0
    // bit14=0
    // bit13=1
    // bit12=1
    // bit11=0
    // bit10=0
    // bit9=1
    // bit8=1
    // bit7=1
    // bit6=0
    // bit5=0
    // bit4=0
    // bit3=0
    // bit2=0
    // bit1=0
    // bit0=0
    //
    // So bits: 0 0 1 1 0 0 1 1 1 0 0 0 0 0 0 0
    // Binary literal: 16'b0011001110000000
    //
    // For clarity, write bits in order (bit15..bit0):
    // 15:0
    // 0 0
    // 1 1
    // 0 0
    // 1 1
    // 1 0
    // 0 0
    // 0 0
    // 0 0
    //
    // Let's re-check carefully bit by bit:
    // bit15 (x=1111) = 0
    // bit14 (1010) = 0
    // bit13 (1101) = 1
    // bit12 (1100) = 1
    // bit11 (1011) = 0
    // bit10 (1010) = 0
    // bit9  (1001) = 1
    // bit8  (1000) = 1
    // bit7  (0111) = 1
    // bit6  (0110) = 0
    // bit5  (0101) = 0
    // bit4  (0100) = 0
    // bit3  (0011) = 0
    // bit2  (0010) = 0
    // bit1  (0001) = 0
    // bit0  (0000) = 0
    //
    // So the literal is 16'b0011_0011_1000_0000

    localparam [15:0] func_vec = 16'b0011001110000000;

    assign f = func_vec[x];

endmodule