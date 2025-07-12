module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Combine states that transition to S0 on input=0
    wire states_to_S0 = state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9];
    assign next_state[0] = states_to_S0 & ~in;

    // Combine states that transition to S1 on input=1
    wire states_to_S1 = state[0] | state[8] | state[9];
    assign next_state[1] = states_to_S1 & in;

    // Single-state transitions on input=1
    assign next_state[2] = state[1] & in;
    assign next_state[3] = state[2] & in;
    assign next_state[4] = state[3] & in;
    assign next_state[5] = state[4] & in;
    assign next_state[6] = state[5] & in;

    // next_state[7] from states 6 and 7 on input=1
    assign next_state[7] = (state[6] | state[7]) & in;

    // Single-state transitions on input=0
    assign next_state[8] = state[5] & ~in;
    assign next_state[9] = state[6] & ~in;

    // Outputs
    assign out1 = |(state & ((1 << 8) | (1 << 9))); // states 8 or 9
    assign out2 = |(state & ((1 << 7) | (1 << 9))); // states 7 or 9

endmodule