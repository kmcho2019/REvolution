module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Group states that transition to S0 on input=0
    wire any_state0_4_7_8_9_3_2_1 = state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9];

    assign next_state[0] = any_state0_4_7_8_9_3_2_1 & ~in;

    // next_state[1] from states 0,8,9 on in=1
    assign next_state[1] = (state[0] | state[8] | state[9]) & in;

    // next_state[2] to S2 from state 1 on in=1
    assign next_state[2] = state[1] & in;

    // next_state[3] to S3 from state 2 on in=1
    assign next_state[3] = state[2] & in;

    // next_state[4] to S4 from state 3 on in=1
    assign next_state[4] = state[3] & in;

    // next_state[5] to S5 from state 4 on in=1
    assign next_state[5] = state[4] & in;

    // next_state[6] to S6 from state 5 on in=1
    assign next_state[6] = state[5] & in;

    // next_state[7] from states 6 and 7 on in=1
    assign next_state[7] = (state[6] | state[7]) & in;

    // next_state[8] from state 5 on in=0
    assign next_state[8] = state[5] & ~in;

    // next_state[9] from state 6 on in=0
    assign next_state[9] = state[6] & ~in;

    // Outputs: out1 = active if states 8 or 9, out2 = active if states 7 or 9
    assign out1 = |(state & 10'b1100000000);  // bits 9 and 8
    assign out2 = |(state & 10'b100000000);   // bits 9 and 7

endmodule