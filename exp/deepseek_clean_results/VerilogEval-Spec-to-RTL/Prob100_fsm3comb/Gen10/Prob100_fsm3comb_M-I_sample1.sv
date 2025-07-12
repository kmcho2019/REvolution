module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Output remains the same (optimal)
assign out = (state == 2'b11); // 1 when in state D

// Optimized next state logic
assign next_state[1] = (~state[1] & state[0] & ~in) |  // B->C when in=0
                      (state[1] & ~state[0] & in) |    // C->D when in=1
                      (state[1] & state[0] & ~in);     // D->C when in=0

// Simplified next_state[0] - depends only on input when not in specific cases
assign next_state[0] = in & ((state == 2'b00) |        // A->B when in=1
                            (state == 2'b01) |        // B->B when in=1
                            (state == 2'b11));        // D->B when in=1
                            // C->D when in=1 is covered by next_state[1]

endmodule