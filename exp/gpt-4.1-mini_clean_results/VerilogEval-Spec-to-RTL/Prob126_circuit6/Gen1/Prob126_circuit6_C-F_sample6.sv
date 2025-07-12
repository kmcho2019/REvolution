module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Define a ROM-like localparam array for lookup table
    localparam [15:0] LUT [0:7] = {
        16'h2f19, // 7
        16'hc526, // 6
        16'h64ce, // 5
        16'h2066, // 4
        16'h5a0e, // 3
        16'h27d4, // 2
        16'haee0, // 1
        16'h1232  // 0
    };

    // Continuous combinational assignment from LUT, handling out-of-range by zero
    assign q = (a < 3'd8) ? LUT[a] : 16'h0000;

endmodule