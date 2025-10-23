module TopModule(
    input  in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to zero
    assign next_state = 10'b0;

    // S0 transitions
    assign next_state[0] = (~in & (state[0] | state[1] | state[2] | state[3] | state[4] | state[8] | state[9])) | (in & state[0]);
    assign next_state[1] = in & state[0];

    // S1 transitions
    assign next_state[0] = next_state[0] | (~in & state[1]);
    assign next_state[2] = in & state[1];

    // S2 transitions
    assign next_state[0] = next_state[0] | (~in & state[2]);
    assign next_state[3] = in & state[2];

    // S3 transitions
    assign next_state[0] = next_state[0] | (~in & state[3]);
    assign next_state[4] = in & state[3];

    // S4 transitions
    assign next_state[0] = next_state[0] | (~in & state[4]);
    assign next_state[5] = in & state[4];

    // S5 transitions
    assign next_state[8] = ~in & state[5];
    assign next_state[6] = in & state[5];

    // S6 transitions
    assign next_state[9] = ~in & state[6];
    assign next_state[7] = in & state[6];

    // S7 transitions
    assign next_state[0] = next_state[0] | (~in & state[7]);
    assign next_state[7] = in & state[7];

    // S8 transitions
    assign next_state[0] = next_state[0] | (~in & state[8]);
    assign next_state[1] = in & state[8];

    // S9 transitions
    assign next_state[0] = next_state[0] | (~in & state[9]);
    assign next_state[1] = in & state[9];

    // Output logic
    assign out1 = state[7] | state[8] | state[9];
    assign out2 = state[7];

endmodule