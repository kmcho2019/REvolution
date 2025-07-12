module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // K-map: cd rows, ab columns
    // Index bits: {c,d,b,a} = [3:0]
    // The K-map is given as:
    // cd\ab 00 01 11 10
    // 00: 1  1  0  1
    // 01: 1  0  0  1
    // 11: 0  1  1  1
    // 10: 1  1  0  0
    //
    // Arrange bits as {c,d,b,a}:
    // We must confirm indexing matches the correct order.
    //
    // Let's map each input pattern to output bit index:
    // Address = {c,d,b,a} (c is MSB)
    //
    // List of inputs and outputs:
    // c d b a | output (from K-map)
    // 0 0 0 0 | 1  (cd=00 ab=00)
    // 0 0 0 1 | 1  (cd=00 ab=01)
    // 0 0 1 1 | 0  (cd=00 ab=11)
    // 0 0 1 0 | 1  (cd=00 ab=10)
    // 0 1 0 0 | 1  (cd=01 ab=00)
    // 0 1 0 1 | 0  (cd=01 ab=01)
    // 0 1 1 1 | 0  (cd=01 ab=11)
    // 0 1 1 0 | 1  (cd=01 ab=10)
    // 1 1 0 0 | 0  (cd=11 ab=00)
    // 1 1 0 1 | 1  (cd=11 ab=01)
    // 1 1 1 1 | 1  (cd=11 ab=11)
    // 1 1 1 0 | 1  (cd=11 ab=10)
    // 1 0 0 0 | 1  (cd=10 ab=00)
    // 1 0 0 1 | 1  (cd=10 ab=01)
    // 1 0 1 1 | 0  (cd=10 ab=11)
    // 1 0 1 0 | 0  (cd=10 ab=10)
    //
    // Construct the LUT (bit 0 is for input 0000 = {c=0,d=0,b=0,a=0}, bit 15 is 1111)
    //
    // Index from 0 to 15 (cdba):
    //  0: 0000 -> 1
    //  1: 0001 -> 1
    //  2: 0010 -> 1 (check 0 0 1 0) yes 1
    //  3: 0011 -> 0
    //  4: 0100 -> 1
    //  5: 0101 -> 0
    //  6: 0110 -> 1
    //  7: 0111 -> 0
    //  8: 1000 -> 1
    //  9: 1001 -> 1
    // 10: 1010 -> 0
    // 11: 1011 -> 0
    // 12: 1100 -> 0
    // 13: 1101 -> 1
    // 14: 1110 -> 1
    // 15: 1111 -> 1
    //
    // Wait, this is not consistent with above mapping because in K-map rows are cd and columns are ab,
    // but here index is {c,d,b,a}. To match K-map, we should reorder bits as {c,d,a,b} or {c,d,b,a}.
    //
    // K-map columns = ab, rows = cd
    // So for the index = (c,d,a,b)
    //
    // Let's do index = {c,d,a,b}
    //
    // Input pattern | Output
    // c d a b | out
    // 0 0 0 0 = 0   | K-map cd=00 ab=00 = 1
    // 0 0 0 1 = 1   | cd=00 ab=01 = 1
    // 0 0 1 1 = 3   | cd=00 ab=11 = 0
    // 0 0 1 0 = 2   | cd=00 ab=10 = 1
    // 0 1 0 0 = 4   | cd=01 ab=00 = 1
    // 0 1 0 1 = 5   | cd=01 ab=01 = 0
    // 0 1 1 1 = 7   | cd=01 ab=11 = 0
    // 0 1 1 0 = 6   | cd=01 ab=10 = 1
    // 1 1 0 0 = 12  | cd=11 ab=00 = 0
    // 1 1 0 1 = 13  | cd=11 ab=01 = 1
    // 1 1 1 1 = 15  | cd=11 ab=11 = 1
    // 1 1 1 0 = 14  | cd=11 ab=10 = 1
    // 1 0 0 0 = 8   | cd=10 ab=00 = 1
    // 1 0 0 1 = 9   | cd=10 ab=01 = 1
    // 1 0 1 1 = 11  | cd=10 ab=11 = 0
    // 1 0 1 0 = 10  | cd=10 ab=10 = 0
    //
    // So LUT bits at indices 0..15:
    // Index: Value
    //  0: 1
    //  1: 1
    //  2: 1
    //  3: 0
    //  4: 1
    //  5: 0
    //  6: 1
    //  7: 0
    //  8: 1
    //  9: 1
    // 10: 0
    // 11: 0
    // 12: 0
    // 13: 1
    // 14: 1
    // 15: 1
    //
    // Binary LUT (bit 15 ... bit 0):
    // bit15 bit14 bit13 bit12 bit11 bit10 bit9 bit8 bit7 bit6 bit5 bit4 bit3 bit2 bit1 bit0
    //   1     1    1    0    0    0   1   1   0   1   0   1   0   1   1   1
    //
    // Let's write from bit15 downto bit0:
    // 1110_0011_0110_1011 in binary
    // Hex: 0xE36B
    //
    // We'll index as LUT[{c,d,a,b}].
    // So address = {c,d,a,b}

    wire [3:0] addr = {c,d,a,b};
    wire [15:0] LUT = 16'hE36B;

    assign out = LUT[addr];
endmodule