module TopModule(
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p1e,
    input p1f,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);

// Intermediate signals for AND gates
wire and_p1a_b_c;
wire and_p1d_e_f;
wire and_p2a_b;
wire and_p2c_d;

// Assign values to intermediate signals
assign and_p1a_b_c = p1a & p1b & p1c;
assign and_p1d_e_f = p1d & p1e & p1f;
assign and_p2a_b = p2a & p2b;
assign and_p2c_d = p2c & p2d;

// Assign outputs
assign p1y = and_p1a_b_c | and_p1d_e_f;
assign p2y = and_p2a_b | and_p2c_d;

endmodule