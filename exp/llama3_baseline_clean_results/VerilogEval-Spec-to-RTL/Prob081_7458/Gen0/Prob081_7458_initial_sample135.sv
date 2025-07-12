module TopModule(
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

// Declare wires for intermediate signals (outputs of AND gates)
wire and_p1a_p1b_p1c;
wire and_p1d_p1e_p1f;
wire and_p2a_p2b;
wire and_p2c_p2d;

// Assign the outputs of the AND gates to the intermediate wires
assign and_p1a_p1b_p1c = p1a & p1b & p1c;
assign and_p1d_p1e_p1f = p1d & p1e & p1f;
assign and_p2a_p2b = p2a & p2b;
assign and_p2c_p2d = p2c & p2d;

// Use the intermediate wires to compute the final outputs
assign p1y = and_p1a_p1b_p1c | and_p1d_p1e_p1f;
assign p2y = and_p2a_p2b | and_p2c_p2d;

endmodule