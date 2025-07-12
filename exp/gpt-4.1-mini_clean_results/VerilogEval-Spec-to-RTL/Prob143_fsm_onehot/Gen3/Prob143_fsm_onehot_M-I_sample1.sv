module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire in_bar = ~in;

    // ns[0]: sum of many state[x] & ~in terms
    // Factor out & in_bar, then OR the states involved
    wire ns0_states = state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9];

    assign next_state[0] = ns0_states & in_bar;

    // ns[1]: (state[0] & in) | (state[8] & in) | (state[9] & in)
    wire ns1_states = state[0] | state[8] | state[9];
    assign next_state[1] = ns1_states & in;

    assign next_state[2] = state[1] & in;
    assign next_state[3] = state[2] & in;
    assign next_state[4] = state[3] & in;
    assign next_state[5] = state[4] & in;
    assign next_state[6] = state[5] & in;

    // ns[7] = (state[6] & in) | (state[7] & in)
    assign next_state[7] = (state[6] | state[7]) & in;

    assign next_state[8] = state[5] & in_bar;
    assign next_state[9] = state[6] & in_bar;

    // Outputs based on current states (as given)
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule