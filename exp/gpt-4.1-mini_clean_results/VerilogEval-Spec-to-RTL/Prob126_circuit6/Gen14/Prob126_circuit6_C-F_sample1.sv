module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Explicit constant definitions for readability
    localparam [15:0] VAL0 = 16'h1232;
    localparam [15:0] VAL1 = 16'haee0;
    localparam [15:0] VAL2 = 16'h27d4;
    localparam [15:0] VAL3 = 16'h5a0e;
    localparam [15:0] VAL4 = 16'h2066;
    localparam [15:0] VAL5 = 16'h64ce;
    localparam [15:0] VAL6 = 16'hc526;
    localparam [15:0] VAL7 = 16'h2f19;

    // Instantiate LUT with constants for direct indexing by 'a'
    wire [15:0] lut [0:7];
    assign lut[0] = VAL0;
    assign lut[1] = VAL1;
    assign lut[2] = VAL2;
    assign lut[3] = VAL3;
    assign lut[4] = VAL4;
    assign lut[5] = VAL5;
    assign lut[6] = VAL6;
    assign lut[7] = VAL7;

    // Combinationally assign output by indexing LUT with input 'a'
    assign q = lut[a];

endmodule