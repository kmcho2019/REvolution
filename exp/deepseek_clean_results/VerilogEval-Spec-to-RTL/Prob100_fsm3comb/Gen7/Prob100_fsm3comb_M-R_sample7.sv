module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Output is 1 only in state D (11)
assign out = &state;  // AND of both state bits (only true for state D)

// Next state logic using state bits directly
assign next_state[1] = (~state[1] & state[0] & ~in) |  // B->C when in=0
                       (state[1] & ~state[0] & in) |   // C->D when in=1
                       (state[1] & state[0] & ~in);     // D->C when in=0

assign next_state[0] = (~state[1] & ~state[0] & in) |  // A->B when in=1
                       (~state[1] & state[0] & in) |    // B->B when in=1
                       (state[1] & ~state[0] & in) |   // C->D when in=1
                       (state[1] & state[0] & in);      // D->B when in=1

endmodule