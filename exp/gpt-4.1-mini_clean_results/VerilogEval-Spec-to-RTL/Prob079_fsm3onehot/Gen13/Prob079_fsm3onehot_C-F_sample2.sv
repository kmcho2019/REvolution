module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // State bits for clarity (one-hot encoding)
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Input inversion to reuse
    wire in_n = ~in;

    // Shared intermediate signals for logic reduction
    wire AorC = A | C;         // used in next_state[0]
    wire BorD = B | D;         // used in next_state[2]
    wire B_and_in = B & in;    // appears multiple times in next_state[1]
    wire D_and_in = D & in;    // appears multiple times in next_state[1]

    // next_state[0] is set by:
    //   A & ~in  (A->A on in=0)
    //   C & ~in  (C->A on in=0)
    assign next_state[0] = in_n & AorC;

    // next_state[1] is set by:
    //   A & in   (A->B on in=1)
    //   B & in   (B->B on in=1)
    //   D & in   (D->B on in=1)
    // Factor out in for clarity and reduce fan-in:
    assign next_state[1] = in & (A | B | D);

    // next_state[2] is set by:
    //   B & ~in  (B->C on in=0)
    //   D & ~in  (D->C on in=0)
    assign next_state[2] = in_n & BorD;

    // next_state[3] is set by:
    //   C & in   (C->D on in=1)
    assign next_state[3] = C & in;

    // Output logic (Moore machine): output=1 only when in state D
    assign out = D;

endmodule