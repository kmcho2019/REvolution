module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// State bit equations derived from transition table
// next_state[1] is true for:
//   Current state B (01) and in=0 -> C (10)
//   Current state C (10) and in=1 -> D (11)
//   Current state D (11) and in=0 -> C (10)
wire next_state_bit1 = (~state[1] & state[0] & ~in) |  // B->C when in=0
                       (state[1] & ~state[0] & in) |     // C->D when in=1
                       (state[1] & state[0] & ~in);     // D->C when in=0

// next_state[0] is true for:
//   Current state A (00) and in=1 -> B (01)
//   Current state B (01) and in=1 -> B (01)
//   Current state D (11) and in=1 -> B (01)
wire next_state_bit0 = (~state[1] & ~state[0] & in) |    // A->B when in=1
                       (~state[1] & state[0] & in) |     // B->B when in=1
                       (state[1] & state[0] & in);      // D->B when in=1

assign next_state = {next_state_bit1, next_state_bit0};
assign out = (state == 2'b11);  // Output 1 only in state D

endmodule