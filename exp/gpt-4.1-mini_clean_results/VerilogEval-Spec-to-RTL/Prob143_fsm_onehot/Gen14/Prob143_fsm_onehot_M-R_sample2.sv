module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;

    // next_state[0]: direct OR of all states transitioning to S0 on input 0
    assign next_state[0] = zero_in & (state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9]);

    // next_state bits for S1 through S9 assigned using explicit conditions
    assign next_state[1] = in & (state[0] | state[8] | state[9]);
    assign next_state[2] = in & state[1];
    assign next_state[3] = in & state[2];
    assign next_state[4] = in & state[3];
    assign next_state[5] = in & state[4];
    assign next_state[6] = in & state[5];
    assign next_state[7] = in & (state[6] | state[7]);
    assign next_state[8] = zero_in & state[5];
    assign next_state[9] = zero_in & state[6];

    // Outputs: directly OR relevant state bits
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule