module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Define inverted input for convenience
    wire not_in = ~in;

    // next_state logic:
    // next_state[0] (S0) activated when any state with input=0 transitions to S0
    assign next_state[0] = (state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9]) & not_in;

    // next_state[1] (S1)
    assign next_state[1] = (state[0] | state[8] | state[9]) & in;

    // next_state[2] (S2)
    assign next_state[2] = state[1] & in;

    // next_state[3] (S3)
    assign next_state[3] = state[2] & in;

    // next_state[4] (S4)
    assign next_state[4] = state[3] & in;

    // next_state[5] (S5)
    assign next_state[5] = state[4] & in;

    // next_state[6] (S6)
    assign next_state[6] = state[5] & in;

    // next_state[7] (S7)
    assign next_state[7] = (state[6] | state[7]) & in;

    // next_state[8] (S8)
    assign next_state[8] = state[5] & not_in;

    // next_state[9] (S9)
    assign next_state[9] = state[6] & not_in;

    // Outputs per problem statement:
    // out1 is 1 if current state includes S8 or S9
    assign out1 = state[8] | state[9];

    // out2 is 1 if current state includes S7 or S9
    assign out2 = state[7] | state[9];

endmodule