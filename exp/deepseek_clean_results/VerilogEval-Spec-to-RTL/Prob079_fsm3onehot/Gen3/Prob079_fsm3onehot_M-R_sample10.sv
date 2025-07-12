module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Output logic remains the same
    assign out = state[3];

    // Next state logic using continuous assignments
    assign next_state[0] = (~state[0] & ~state[1] & ~state[2] & ~state[3]) |  // Default to A
                          (state[0] & ~in) |                                  // A->A when in=0
                          (state[2] & ~in);                                   // C->A when in=0

    assign next_state[1] = (state[0] & in) |                                  // A->B when in=1
                          (state[1] & in) |                                   // B->B when in=1
                          (state[3] & in);                                    // D->B when in=1

    assign next_state[2] = (state[1] & ~in) |                                 // B->C when in=0
                          (state[3] & ~in);                                   // D->C when in=0

    assign next_state[3] = (state[2] & in);                                   // C->D when in=1

endmodule