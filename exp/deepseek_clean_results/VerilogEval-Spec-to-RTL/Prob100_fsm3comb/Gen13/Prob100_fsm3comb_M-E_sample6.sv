module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Output is 1 only when in state D (11)
assign out = state[1] & state[0];

// Next state logic:
// next_state[1] = (state==B & ~in) | (state==C & in) | (state==D & ~in)
// next_state[0] = (state==A & in) | (state==B & in) | (state==D & in)

assign next_state[1] = (~state[1] & state[0] & ~in) |  // B->C when in=0
                      (state[1] & ~state[0] & in) |    // C->D when in=1
                      (state[1] & state[0] & ~in);    // D->C when in=0

assign next_state[0] = (~state[1] & ~state[0] & in) |  // A->B when in=1
                      (~state[1] & state[0] & in) |    // B->B when in=1
                      (state[1] & state[0] & in);      // D->B when in=1

endmodule