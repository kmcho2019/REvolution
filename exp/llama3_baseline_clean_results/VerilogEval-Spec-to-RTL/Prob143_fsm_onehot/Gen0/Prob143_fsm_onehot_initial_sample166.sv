module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to zero
    assign next_state = 10'b0;

    // Initialize out1 and out2 to zero
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    // S0 logic
    assign next_state[0] = (state[0] && !in) | (state[1] && !in) | (state[2] && !in) | (state[3] && !in) | (state[4] && !in) | (state[8] && !in) | (state[9] && !in);

    // S1 logic
    assign next_state[1] = (state[0] && in) | (state[8] && in) | (state[9] && in);

    // S2 logic
    assign next_state[2] = (state[1] && in);

    // S3 logic
    assign next_state[3] = (state[2] && in);

    // S4 logic
    assign next_state[4] = (state[3] && in);

    // S5 logic
    assign next_state[5] = (state[4] && in);

    // S6 logic
    assign next_state[6] = (state[5] && in);

    // S7 logic
    assign next_state[7] = (state[6] && in);
    assign out2 = state[7];

    // S8 logic
    assign next_state[8] = (state[5] && !in);
    assign out1 = state[8];

    // S9 logic
    assign next_state[9] = (state[6] && !in);
    assign out1 = state[9] | out1;
    assign out2 = state[9] | out2;

endmodule