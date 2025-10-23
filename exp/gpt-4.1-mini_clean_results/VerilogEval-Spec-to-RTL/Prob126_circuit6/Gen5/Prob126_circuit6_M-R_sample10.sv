module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Concatenate all constants into one big vector (8 entries * 16 bits = 128 bits)
    localparam [127:0] LUT = {
        16'h2f19, // a=7
        16'hc526, // a=6
        16'h64ce, // a=5
        16'h2066, // a=4
        16'h5a0e, // a=3
        16'h27d4, // a=2
        16'haee0, // a=1
        16'h1232  // a=0
    };

    // Select the 16-bit word from LUT using a as an index
    assign q = LUT >> (a * 16);

endmodule