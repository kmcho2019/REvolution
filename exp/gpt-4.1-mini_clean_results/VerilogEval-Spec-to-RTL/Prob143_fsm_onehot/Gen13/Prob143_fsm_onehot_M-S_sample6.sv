module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // States that transition to S0 on input=0
    wire zero_to_s0_states = state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9];

    // next_state assignments simplified:
    assign next_state[0] = zero_to_s0_states & ~in;
    assign next_state[1] = (state[0] | state[8] | state[9]) & in;
    assign next_state[2] = state[1] & in;
    assign next_state[3] = state[2] & in;
    assign next_state[4] = state[3] & in;
    assign next_state[5] = state[4] & in;
    assign next_state[6] = state[5] & in;
    assign next_state[7] = (state[6] | state[7]) & in;
    assign next_state[8] = state[5] & ~in;
    assign next_state[9] = state[6] & ~in;

    // outputs: out1 = 1 if in S8 or S9; out2 = 1 if in S7 or S9
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule