module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Concatenate all 8 16-bit constants into one 128-bit vector
    // Ordered from a=7 down to a=0 for convenient shifting
    localparam [127:0] LUT_VEC = {
        16'h2f19, // a=7
        16'hc526, // a=6
        16'h64ce, // a=5
        16'h2066, // a=4
        16'h5a0e, // a=3
        16'h27d4, // a=2
        16'haee0, // a=1
        16'h1232  // a=0
    };

    // Select the 16-bit slice corresponding to input 'a'
    // Shift right by (a * 16) bits and extract lower 16 bits
    assign q = LUT_VEC >> (a * 16);

endmodule