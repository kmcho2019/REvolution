module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Define a packed constant array holding all ROM values
    localparam [15:0] ROM [0:7] = {
        16'h2f19, // a=7
        16'hc526, // a=6
        16'h64ce, // a=5
        16'h2066, // a=4
        16'h5a0e, // a=3
        16'h27d4, // a=2
        16'haee0, // a=1
        16'h1232  // a=0
    };

    // Since SystemVerilog allows constant arrays indexed by input,
    // reverse order to index properly (or just index directly):
    // We'll re-order to ascending index to avoid confusion:

    localparam [15:0] ROM_asc [0:7] = {
        16'h1232, // a=0
        16'haee0, // a=1
        16'h27d4, // a=2
        16'h5a0e, // a=3
        16'h2066, // a=4
        16'h64ce, // a=5
        16'hc526, // a=6
        16'h2f19  // a=7
    };

    assign q = ROM_asc[a];

endmodule