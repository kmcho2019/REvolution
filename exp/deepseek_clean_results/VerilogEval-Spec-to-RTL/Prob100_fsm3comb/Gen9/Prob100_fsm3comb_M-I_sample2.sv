module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Output is 1 only in state D (Moore machine)
assign out = state[1] & state[0];

// Optimized next state logic
assign next_state[1] = (state[0] & ~in) |  // B->C or D->C when in=0
                      (state[1] & ~state[0] & in); // C->D when in=1

assign next_state[0] = in & (~state[1] | state[0]); // A->B, B->B, C->D, D->B when in=1

endmodule