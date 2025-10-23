module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    assign next_state[0] = (A & ~in) | (C & ~in);  // A->A if in=0, C->A if in=0
    assign next_state[1] = (A & in)  | (B & in) | (D & in); // A->B, B->B, D->B if in=1
    assign next_state[2] = (B & ~in) | (D & ~in);  // B->C, D->C if in=0
    assign next_state[3] = (C & in);                // C->D if in=1

    assign out = D;

endmodule