module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Single 16-bit LUT array storing all values
    wire [15:0] lut [0:7];

    assign lut[0] = 16'h1232;
    assign lut[1] = 16'haee0;
    assign lut[2] = 16'h27d4;
    assign lut[3] = 16'h5a0e;
    assign lut[4] = 16'h2066;
    assign lut[5] = 16'h64ce;
    assign lut[6] = 16'hc526;
    assign lut[7] = 16'h2f19;

    // Combinational assignment of q
    assign q = lut[a];

endmodule