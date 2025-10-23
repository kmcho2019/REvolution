module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Next state when in=0: states that go to S0
    wire next0_0 = state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9];
    // Next state when in=1: states that go to S1
    wire next1_1 = state[0] | state[8] | state[9];

    assign next_state[0] = (~in & next0_0) | (state[7] & ~in); // state[7] already included in next0_0
    assign next_state[1] = (in & next1_1);
    assign next_state[2] = state[1] & in;
    assign next_state[3] = state[2] & in;
    assign next_state[4] = state[3] & in;
    assign next_state[5] = state[4] & in;
    assign next_state[6] = state[5] & in;
    assign next_state[7] = (state[6] & in) | (state[7] & in);
    assign next_state[8] = state[5] & ~in;
    assign next_state[9] = state[6] & ~in;

    // Outputs directly from active states
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule