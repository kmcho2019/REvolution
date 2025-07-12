module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,   // don't care, but included in LUT index
    output out
);

    // Build a 16-bit LUT for all combinations of (a,b,c,d)
    // Indexing: {a,b,c,d} as bits [3:0]
    // Using the Karnaugh map to set output to 1 where specified,
    // treating 'd' as relevant for LUT indexing (but ignoring its effect on logic)

    wire [15:0] lut = 16'b1111111100101110;
    // Explanation:
    // bit 0  = abcd=0000 => d (don't-care) => 0 chosen
    // bit 1  = 0001 => 0
    // bit 2  = 0010 => 1 (from K-map)
    // bit 3  = 0011 => 1
    // bit 4  = 0100 => 0
    // bit 5  = 0101 => 0
    // bit 6  = 0110 => d => 0 chosen
    // bit 7  = 0111 => d => 0 chosen
    // bit 8  = 1000 => 0
    // bit 9  = 1001 => 1
    // bit 10 = 1010 => 1
    // bit 11 = 1011 => 1
    // bit 12 = 1100 => 0
    // bit 13 = 1101 => 1
    // bit 14 = 1110 => 1
    // bit 15 = 1111 => 1

    wire [3:0] idx = {a,b,c,d};

    assign out = lut[idx];

endmodule