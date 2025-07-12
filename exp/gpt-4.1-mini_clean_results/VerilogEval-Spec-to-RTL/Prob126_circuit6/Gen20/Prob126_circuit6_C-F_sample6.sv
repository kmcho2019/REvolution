module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Define a localparam array as a ROM lookup table for output values
    localparam [15:0] LUT [0:7] = {
        16'h1232, // a=0
        16'haee0, // a=1
        16'h27d4, // a=2
        16'h5a0e, // a=3
        16'h2066, // a=4
        16'h64ce, // a=5
        16'hc526, // a=6
        16'h2f19  // a=7
    };

    // Combinational output assigned by indexing LUT with input 'a'
    assign q = LUT[a];

endmodule