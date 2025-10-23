module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Calculate each bit of next_state separately
    assign next_state[0] = (state[0] & ~in) |          // S0->S0 when in=0
                          (state[1] & ~in) |          // S1->S0 when in=0
                          (state[2] & ~in) |          // S2->S0 when in=0
                          (state[3] & ~in) |          // S3->S0 when in=0
                          (state[4] & ~in) |          // S4->S0 when in=0
                          (state[7] & ~in) |          // S7->S0 when in=0
                          (state[8] & ~in) |          // S8->S0 when in=0
                          (state[9] & ~in);           // S9->S0 when in=0

    assign next_state[1] = (state[0] & in) |          // S0->S1 when in=1
                          (state[8] & in) |          // S8->S1 when in=1
                          (state[9] & in);           // S9->S1 when in=1

    assign next_state[2] = (state[1] & in);           // S1->S2 when in=1

    assign next_state[3] = (state[2] & in);           // S2->S3 when in=1

    assign next_state[4] = (state[3] & in);           // S3->S4 when in=1

    assign next_state[5] = (state[4] & in);           // S4->S5 when in=1

    assign next_state[6] = (state[5] & in);           // S5->S6 when in=1

    assign next_state[7] = (state[6] & in) |          // S6->S7 when in=1
                          (state[7] & in);           // S7->S7 when in=1

    assign next_state[8] = (state[5] & ~in);          // S5->S8 when in=0

    assign next_state[9] = (state[6] & ~in);          // S6->S9 when in=0

    // Output logic remains the same (correct in original)
    assign out1 = state[8] | state[9];  // S8 or S9 active
    assign out2 = state[7] | state[9];  // S7 or S9 active

endmodule