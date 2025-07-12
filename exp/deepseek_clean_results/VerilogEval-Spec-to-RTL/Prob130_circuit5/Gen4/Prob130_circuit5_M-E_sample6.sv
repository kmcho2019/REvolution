module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// LUT-style implementation with priority encoding
wire [3:0] lut [0:3];
assign lut[0] = b;
assign lut[1] = e;
assign lut[2] = a;
assign lut[3] = d;

// Output selection
assign q = (c < 4) ? lut[c] : 4'b1111;

endmodule