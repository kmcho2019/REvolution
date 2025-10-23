module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire in_0 = ~in;
    wire in_1 =  in;

    // Compute each next_state bit as the OR of all states that transition to it for the given input.

    // Next state S0:
    // Transitions to S0 on input 0: S0,S1,S2,S3,S4,S7,S8,S9
    // So, next_state[0] = (S0 & ~in) | (S1 & ~in) | (S2 & ~in) | (S3 & ~in) | (S4 & ~in) | (S7 & ~in) | (S8 & ~in) | (S9 & ~in)
    assign next_state[0] = (state[0] & in_0) | (state[1] & in_0) | (state[2] & in_0) | (state[3] & in_0) |
                          (state[4] & in_0) | (state[7] & in_0) | (state[8] & in_0) | (state[9] & in_0);

    // Next state S1:
    // On input 1 from S0, S8, S9
    assign next_state[1] = (state[0] & in_1) | (state[8] & in_1) | (state[9] & in_1);

    // Next state S2:
    // On input 1 from S1
    assign next_state[2] = state[1] & in_1;

    // Next state S3:
    // On input 1 from S2
    assign next_state[3] = state[2] & in_1;

    // Next state S4:
    // On input 1 from S3
    assign next_state[4] = state[3] & in_1;

    // Next state S5:
    // On input 1 from S4
    assign next_state[5] = state[4] & in_1;

    // Next state S6:
    // On input 1 from S5
    assign next_state[6] = state[5] & in_1;

    // Next state S7:
    // On input 1 from S6 and S7
    assign next_state[7] = (state[6] & in_1) | (state[7] & in_1);

    // Next state S8:
    // On input 0 from S5
    assign next_state[8] = state[5] & in_0;

    // Next state S9:
    // On input 0 from S6
    assign next_state[9] = state[6] & in_0;

    // Outputs:
    // out1 = 1 if state includes S8 or S9
    assign out1 = state[8] | state[9];

    // out2 = 1 if state includes S7 or S9
    assign out2 = state[7] | state[9];

endmodule