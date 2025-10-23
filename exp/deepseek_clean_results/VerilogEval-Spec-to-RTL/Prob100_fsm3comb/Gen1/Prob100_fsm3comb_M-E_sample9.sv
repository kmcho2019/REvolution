module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Next state logic (derived from truth table)
// next_state[1] = (state==C & ~in) | (state==D & ~in) | (state==C & in)
assign next_state[1] = (state[1] & ~state[0] & ~in) |  // C & ~in -> A (0)
                      (state[1] & state[0] & ~in) |    // D & ~in -> C (1)
                      (state[1] & ~state[0] & in);     // C & in -> D (1)

// next_state[0] = (state==A & in) | (state==B & in) | (state==D & in) | (state==B & ~in)
assign next_state[0] = (~state[1] & ~state[0] & in) |  // A & in -> B (1)
                       (~state[1] & state[0] & in) |   // B & in -> B (1)
                       (state[1] & state[0] & in) |    // D & in -> B (1)
                       (~state[1] & state[0] & ~in);   // B & ~in -> C (0)

// Output is high only when in state D (11)
assign out = state[1] & state[0];

endmodule