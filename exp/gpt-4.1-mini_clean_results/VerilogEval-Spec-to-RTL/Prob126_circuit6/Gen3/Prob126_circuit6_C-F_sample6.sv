module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Define a localparam array for all possible outputs indexed by 'a'
    localparam [15:0] LUT [0:7] = {
        16'h2f19, // a=7
        16'hc526, // a=6
        16'h64ce, // a=5
        16'h2066, // a=4
        16'h5a0e, // a=3
        16'h27d4, // a=2
        16'haee0, // a=1
        16'h1232  // a=0
    };

    // Because the array is declared descending from index 7 to 0, 
    // we must reverse the index or declare ascending to use a directly:
    // So redefine ascending for simplicity:

    localparam [15:0] LUT_ASC [0:7] = {
        16'h1232, // a=0
        16'haee0, // a=1
        16'h27d4, // a=2
        16'h5a0e, // a=3
        16'h2066, // a=4
        16'h64ce, // a=5
        16'hc526, // a=6
        16'h2f19  // a=7
    };

    // Assign output using the lookup table
    assign q = LUT_ASC[a];

endmodule