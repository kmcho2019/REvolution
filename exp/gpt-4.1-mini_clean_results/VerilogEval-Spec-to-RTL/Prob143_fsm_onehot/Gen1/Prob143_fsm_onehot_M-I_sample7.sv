module TopModule(
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// For each next_state bit, compute the OR of all possible state transitions activating it

wire s0_active_0 = (state[0] & ~in) | (state[1] & ~in) | (state[2] & ~in) | (state[3] & ~in) | (state[4] & ~in) | (state[7] & ~in) | (state[8] & ~in) | (state[9] & ~in);
wire s0_active_1 = 1'b0; // no transition targets S0 other than above (already covered)
wire s0 = s0_active_0 | s0_active_1;

wire s1 = (state[0] & in) | (state[8] & in) | (state[9] & in);
wire s2 = (state[1] & in);
wire s3 = (state[2] & in);
wire s4 = (state[3] & in);
wire s5 = (state[4] & in);
wire s6 = (state[5] & in);
wire s7 = (state[6] & in) | (state[7] & in);
wire s8 = (state[5] & ~in);
wire s9 = (state[6] & ~in);

assign next_state = {s9, s8, s7, s6, s5, s4, s3, s2, s1, s0};

// Outputs: out1 is set by states S8 and S9; out2 is set by states S7 and S9
assign out1 = (state[8]) | (state[9]);
assign out2 = (state[7]) | (state[9]);

endmodule