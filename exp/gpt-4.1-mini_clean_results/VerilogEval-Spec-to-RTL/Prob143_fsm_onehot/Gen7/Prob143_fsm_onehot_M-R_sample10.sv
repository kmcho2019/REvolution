module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // next_state[0]: transitions to S0 on input=0 from states S0,S1,S2,S3,S4,S7,S8,S9
    assign next_state[0] = (~in) & (
          state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9]
    );

    // next_state[1]: transitions to S1 on input=1 from S0, S8, S9
    assign next_state[1] = in & (state[0] | state[8] | state[9]);

    // next_state[2] through next_state[6]: single state transitions on input=1
    assign next_state[2] = in & state[1];
    assign next_state[3] = in & state[2];
    assign next_state[4] = in & state[3];
    assign next_state[5] = in & state[4];
    assign next_state[6] = in & state[5];

    // next_state[7]: transitions to S7 on input=1 from S6 and S7
    assign next_state[7] = in & (state[6] | state[7]);

    // next_state[8] and next_state[9]: transitions from S5 and S6 on input=0
    assign next_state[8] = (~in) & state[5];
    assign next_state[9] = (~in) & state[6];

    // Outputs:
    // out1 = state 8 or 9
    assign out1 = state[8] | state[9];

    // out2 = state 7 or 9
    assign out2 = state[7] | state[9];

endmodule