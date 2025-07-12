module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Next state bit 1 logic
assign next_state[1] = (~state[1] & state[0] & ~in) |  // B->C when in=0
                      (state[1] & ~state[0]) |         // C->A or C->D
                      (state[1] & state[0] & ~in);     // D->C when in=0

// Next state bit 0 logic
assign next_state[0] = (~state[1] & ~state[0] & in) |  // A->B when in=1
                      (~state[1] & state[0]) |         // B->B or B->C
                      (state[1] & ~state[0] & in) |    // C->D when in=1
                      (state[1] & state[0] & in);      // D->B when in=1

// Output logic
assign out = (state == 2'b11);

endmodule