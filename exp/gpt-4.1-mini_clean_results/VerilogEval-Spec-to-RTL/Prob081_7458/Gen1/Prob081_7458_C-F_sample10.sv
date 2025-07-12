module TopModule (
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p1e,
    input  p1f,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

// Intermediate wires for the 7458 chip's four AND gates
wire p1_and_upper;  // AND of p1a, p1b, p1c
wire p1_and_lower;  // AND of p1d, p1e, p1f
wire p2_and_left;   // AND of p2a, p2b
wire p2_and_right;  // AND of p2c, p2d

assign p1_and_upper = p1a & p1b & p1c;
assign p1_and_lower = p1d & p1e & p1f;
assign p1y = p1_and_upper | p1_and_lower;

assign p2_and_left = p2a & p2b;
assign p2_and_right = p2c & p2d;
assign p2y = p2_and_left | p2_and_right;

endmodule