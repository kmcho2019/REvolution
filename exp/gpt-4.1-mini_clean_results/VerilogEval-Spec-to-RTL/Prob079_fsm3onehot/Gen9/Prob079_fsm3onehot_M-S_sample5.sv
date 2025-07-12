module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // State bits for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state logic simplified: direct OR of next states from input and current state
    assign next_state[0] = (A & ~in) | (C & ~in);   // A -> A on in=0, C->A on in=0
    assign next_state[1] = (A & in)  | (B & in) | (D & in); // A->B in=1, B->B in=1, D->B in=1
    assign next_state[2] = (B & ~in) | (D & ~in);   // B->C in=0, D->C in=0
    assign next_state[3] = (C & in);                 // C->D in=1

    // Output is high only in state D (Moore output)
    assign out = D;

endmodule