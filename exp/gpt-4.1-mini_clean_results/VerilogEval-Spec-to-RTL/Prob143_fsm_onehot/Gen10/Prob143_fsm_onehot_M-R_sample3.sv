module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // next_state[0] goes high when input is 0 and current states are among those that transition to S0 on 0
    assign next_state[0] = zero_in & (
          state[0]  // S0 -> S0 on 0
        | state[1]  // S1 -> S0 on 0
        | state[2]  // S2 -> S0 on 0
        | state[3]  // S3 -> S0 on 0
        | state[4]  // S4 -> S0 on 0
        | state[7]  // S7 -> S0 on 0
        | state[8]  // S8 -> S0 on 0
        | state[9]  // S9 -> S0 on 0
    );

    // next_state assignments for other states on input 1 or 0 per FSM transition
    assign next_state[1] = one_in & (state[0] | state[8] | state[9]);
    assign next_state[2] = one_in & state[1];
    assign next_state[3] = one_in & state[2];
    assign next_state[4] = one_in & state[3];
    assign next_state[5] = one_in & state[4];
    assign next_state[6] = one_in & state[5];
    assign next_state[7] = one_in & (state[6] | state[7]);
    assign next_state[8] = zero_in & state[5];
    assign next_state[9] = zero_in & state[6];

    // Output logic using explicit OR gates instead of bitmasking
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule