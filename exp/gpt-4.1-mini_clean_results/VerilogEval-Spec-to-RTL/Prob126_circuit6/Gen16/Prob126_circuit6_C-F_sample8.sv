module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Define ROM contents as a localparam array of 16-bit values
    localparam [15:0] ROM [0:7] = {
        16'h2f19, // a=7 (MSB in Verilog packed array initializer)
        16'hc526, // 6
        16'h64ce, // 5
        16'h2066, // 4
        16'h5a0e, // 3
        16'h27d4, // 2
        16'haee0, // 1
        16'h1232  // 0 (LSB)
    };

    // Since Verilog arrays initialize with highest index first, we index as ROM[7 - a]
    assign q = ROM[7 - a];

endmodule