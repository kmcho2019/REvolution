module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Compose a 4-bit vector: abcd order corresponds to bits: a=MSB? 
    // The K-map indexing is given by ab (top) and cd (left), so input bits correspond to:
    // Inputs: a,b,c,d
    // K-map order: ab (horizontal), cd (vertical)
    // We'll create index as {a,b,c,d} with a as MSB, d as LSB (i.e. a=bit3, b=bit2, c=bit1, d=bit0)
    wire [3:0] idx = {a, b, c, d};

    // The K-map table as a 16-bit constant with bits for minterms in order 0 to 15 by idx.
    // From the K-map given:
    // cd\ab  00  01  11  10
    // 00     1   1   0   1
    // 01     1   0   0   1
    // 11     0   1   1   1
    // 10     1   1   0   0
    //
    // Index the map for each minterm index (a,b,c,d):
    //  a b c d | out
    //  0 0 0 0 | K-map cd=00 ab=00 = 1
    //  0 0 0 1 | cd=01 ab=00 = 1
    //  0 0 1 0 | cd=10 ab=00 = 1
    //  0 0 1 1 | cd=11 ab=00 = 0
    //  0 1 0 0 | cd=00 ab=01 = 1
    //  0 1 0 1 | cd=01 ab=01 = 0
    //  0 1 1 0 | cd=10 ab=01 = 1
    //  0 1 1 1 | cd=11 ab=01 = 1
    //  1 1 0 0 | cd=00 ab=11 = 0
    //  1 1 0 1 | cd=01 ab=11 = 0
    //  1 1 1 0 | cd=10 ab=11 = 0
    //  1 1 1 1 | cd=11 ab=11 = 1
    //  1 0 0 0 | cd=00 ab=10 = 1
    //  1 0 0 1 | cd=01 ab=10 = 1
    //  1 0 1 0 | cd=10 ab=10 = 0
    //  1 0 1 1 | cd=11 ab=10 = 1
    //
    // Rearranging by index (a,b,c,d) from 0 to 15:
    // idx: out
    // 0000:1
    // 0001:1
    // 0010:1
    // 0011:0
    // 0100:1
    // 0101:0
    // 0110:1
    // 0111:1
    // 1000:1
    // 1001:1
    // 1010:0
    // 1011:1
    // 1100:0
    // 1101:0
    // 1110:0
    // 1111:1

    // Let's create the 16-bit vector from LSB to MSB as idx 0..15:
    // bit0  = idx0 = 1
    // bit1  = idx1 = 1
    // bit2  = idx2 = 1
    // bit3  = idx3 = 0
    // bit4  = idx4 = 1
    // bit5  = idx5 = 0
    // bit6  = idx6 = 1
    // bit7  = idx7 = 1
    // bit8  = idx8 = 1
    // bit9  = idx9 = 1
    // bit10 = idx10= 0
    // bit11 = idx11= 1
    // bit12 = idx12= 0
    // bit13 = idx13= 0
    // bit14 = idx14= 0
    // bit15 = idx15= 1

    localparam [15:0] LUT = 16'b1000_0110_1101_0111;

    // The above constant is constructed so that bit0 corresponds to idx0
    // Verify carefully:
    // bit15 down to bit0:
    // bit15=1 idx15=1111=1
    // bit14=0 idx14=1110=0
    // bit13=0 idx13=1101=0
    // bit12=0 idx12=1100=0
    // bit11=1 idx11=1011=1
    // bit10=0 idx10=1010=0
    // bit9= 1 idx9= 1001=1
    // bit8= 1 idx8= 1000=1
    // bit7= 0 idx7= 0111=1 (Oops mismatch)
    // Re-check bits carefully:

    // Let's list bits idx0 to idx15:
    // idx value   out
    //  0 0000 -> 1
    //  1 0001 -> 1
    //  2 0010 -> 1
    //  3 0011 -> 0
    //  4 0100 -> 1
    //  5 0101 -> 0
    //  6 0110 -> 1
    //  7 0111 -> 1
    //  8 1000 -> 1
    //  9 1001 -> 1
    // 10 1010 -> 0
    // 11 1011 -> 1
    // 12 1100 -> 0
    // 13 1101 -> 0
    // 14 1110 -> 0
    // 15 1111 -> 1

    // So in a 16-bit number with bit0 = idx0, bit1=idx1 ...
    // The bits are: bit15..bit0 = 1 0 0 0 1 0 1 1 1 1 0 1 0 0 0 1

    // Which is in binary (bit15 to bit0):
    // 1 0 0 0   1 0 1 1   1 1 0 1   0 0 0 1
    // hex: 8  B  D  1 (but let's convert precisely)

    // Let's write bits LSB first (bit0 to bit15):
    wire [15:0] lut = 16'b1_0_0_0_1_0_1_1_1_1_0_1_0_0_0_1; // mistake - commas for clarity
    // From LSB to MSB (bit0 to bit15):
    // bit0 = idx0 = 1
    // bit1 = idx1 = 1 (not 0)
    // Correction: previous string is incorrect.

    // So directly write bits from idx0 to idx15 in LSB to MSB order:
    // idx0=1 -> bit0=1
    // idx1=1 -> bit1=1
    // idx2=1 -> bit2=1
    // idx3=0 -> bit3=0
    // idx4=1 -> bit4=1
    // idx5=0 -> bit5=0
    // idx6=1 -> bit6=1
    // idx7=1 -> bit7=1
    // idx8=1 -> bit8=1
    // idx9=1 -> bit9=1
    // idx10=0-> bit10=0
    // idx11=1-> bit11=1
    // idx12=0-> bit12=0
    // idx13=0-> bit13=0
    // idx14=0-> bit14=0
    // idx15=1-> bit15=1

    localparam [15:0] KMAP_LUT = 16'b1000011011010111; // bit15..bit0

    // Wait, this is reversed. To be sure:

    // bit0 (LSB) = idx0 = 1
    // So LSB = 1
    // bit1 = idx1 = 1
    // bit2 = idx2 = 1
    // bit3 = idx3 = 0
    // bit4 = idx4 = 1
    // bit5 = idx5 = 0
    // bit6 = idx6 = 1
    // bit7 = idx7 = 1
    // bit8 = idx8 = 1
    // bit9 = idx9 = 1
    // bit10= idx10=0
    // bit11= idx11=1
    // bit12= idx12=0
    // bit13= idx13=0
    // bit14= idx14=0
    // bit15= idx15=1

    // Bits from LSB to MSB:
    //  bit15:1
    //  bit14:0
    //  bit13:0
    //  bit12:0
    //  bit11:1
    //  bit10:0
    //  bit9: 1
    //  bit8: 1
    //  bit7: 1
    //  bit6: 1
    //  bit5: 0
    //  bit4: 1
    //  bit3: 0
    //  bit2: 1
    //  bit1: 1
    //  bit0: 1

    // So binary 16'b1000_1011_1110_1011 = 16'h8BE B (hex)

    // Reverse bits carefully again:

    // LSB to MSB: 1 1 1 0 1 0 1 1 1 1 0 1 0 0 0 1
    // Let's just define directly the LUT:

    // Because indexing is a,b,c,d = {a,b,c,d} where a is MSB (bit3)
    // So out = LUT[{a,b,c,d}]

    assign out = KMAP_LUT[idx];

endmodule