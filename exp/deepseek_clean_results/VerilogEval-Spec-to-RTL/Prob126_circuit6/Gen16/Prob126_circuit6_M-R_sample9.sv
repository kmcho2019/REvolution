module TopModule (
    input [2:0] a,
    output [15:0] q
);

// ROM-style lookup table
wire [15:0] lookup [0:7];
assign lookup[0] = 16'h1232;
assign lookup[1] = 16'haee0;
assign lookup[2] = 16'h27d4;
assign lookup[3] = 16'h5a0e;
assign lookup[4] = 16'h2066;
assign lookup[5] = 16'h64ce;
assign lookup[6] = 16'hc526;
assign lookup[7] = 16'h2f19;

// Output assignment
assign q = lookup[a];

endmodule