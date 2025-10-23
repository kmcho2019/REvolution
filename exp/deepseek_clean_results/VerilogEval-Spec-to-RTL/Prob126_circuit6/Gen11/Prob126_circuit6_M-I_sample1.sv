module TopModule (
    input [2:0] a,
    output [15:0] q
);

// Packed array of output values
wire [15:0] rom [0:7];
assign rom[0] = 16'h1232;
assign rom[1] = 16'haee0;
assign rom[2] = 16'h27d4;
assign rom[3] = 16'h5a0e;
assign rom[4] = 16'h2066;
assign rom[5] = 16'h64ce;
assign rom[6] = 16'hc526;
assign rom[7] = 16'h2f19;

// Direct lookup
assign q = rom[a];

endmodule