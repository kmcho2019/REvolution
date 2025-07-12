module TopModule (
    input [2:0] a,
    output [15:0] q
);

localparam [15:0] LUT [0:7] = '{
    16'h1232, // 0
    16'haee0, // 1
    16'h27d4, // 2
    16'h5a0e, // 3
    16'h2066, // 4
    16'h64ce, // 5
    16'hc526, // 6
    16'h2f19  // 7
};

assign q = LUT[a];

endmodule