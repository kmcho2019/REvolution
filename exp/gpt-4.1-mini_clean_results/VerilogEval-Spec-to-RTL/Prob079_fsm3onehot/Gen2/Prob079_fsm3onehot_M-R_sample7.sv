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

    // Next state signals computed as OR of all conditions leading to that state

    // next_state A: when (A & ~in) or (C & ~in)
    wire next_A_from_A = A & ~in;
    wire next_A_from_C = C & ~in;
    assign next_state[0] = next_A_from_A | next_A_from_C;

    // next_state B: when (A & in) or (B & in) or (D & in)
    wire next_B_from_A = A & in;
    wire next_B_from_B = B & in;
    wire next_B_from_D = D & in;
    assign next_state[1] = next_B_from_A | next_B_from_B | next_B_from_D;

    // next_state C: when (B & ~in) or (D & ~in)
    wire next_C_from_B = B & ~in;
    wire next_C_from_D = D & ~in;
    assign next_state[2] = next_C_from_B | next_C_from_D;

    // next_state D: when (C & in)
    assign next_state[3] = C & in;

    // Output logic: output=1 only in state D
    assign out = D;

endmodule