module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Single packed constant vector for LUT entries (8 entries x 16 bits = 128 bits)
    localparam [8*16-1:0] LUT_PACKED = {
        16'h2f19, // a=7
        16'hc526, // a=6
        16'h64ce, // a=5
        16'h2066, // a=4
        16'h5a0e, // a=3
        16'h27d4, // a=2
        16'haee0, // a=1
        16'h1232  // a=0
    };

    // Extract the 16-bit output by indexing the packed vector
    assign q = LUT_PACKED >> (a * 16);

endmodule