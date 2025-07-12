module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Define a packed ROM-like array of 16-bit constants
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

    // Assign output using indexed lookup with proper input range check
    assign q = (a <= 3'd7) ? LUT[a] : 16'h0000;

endmodule