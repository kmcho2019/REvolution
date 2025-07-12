module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Next state logic using continuous assignments
assign next_state[1] = (~state[1] & state[0] & ~in) |  // B->C when in=0
                       (state[1] & ~state[0] & in) |   // C->D when in=1
                       (state[1] & state[0] & ~in);    // D->C when in=0

assign next_state[0] = (~state[1] & ~state[0] & in) |  // A->B when in=1
                       (~state[1] & state[0]) |        // B stays when in=1, or
                       (state[1] & ~state[0] & in) |   // C->D when in=1
                       (state[1] & state[0] & in);     // D->B when in=1

// Output logic remains the same
assign out = (state == 2'b11); // Output 1 only in state D

endmodule