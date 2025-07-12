module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // One-hot state bits
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state logic derived from transition table:
    // For in=0: A->A, B->C, C->A, D->C
    // For in=1: A->B, B->B, C->D, D->B

    // next_state[0] is A: active when (A or C) and in=0
    assign next_state[0] = (A | C) & ~in;

    // next_state[1] is B: active when in=1 and (A or B or D)
    assign next_state[1] = in & (A | B | D);

    // next_state[2] is C: active when (B or D) and in=0
    assign next_state[2] = (B | D) & ~in;

    // next_state[3] is D: active when C and in=1
    assign next_state[3] = C & in;

    // Output is 1 only in state D (one-hot encoding)
    assign out = D;

endmodule