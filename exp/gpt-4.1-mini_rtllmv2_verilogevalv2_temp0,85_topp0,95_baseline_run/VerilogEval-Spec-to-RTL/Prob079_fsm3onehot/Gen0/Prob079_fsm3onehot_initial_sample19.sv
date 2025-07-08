module TopModule(
    input  wire       in,
    input  wire [3:0] state,      // one-hot encoded current state: A=0001, B=0010, C=0100, D=1000
    output wire [3:0] next_state, // one-hot encoded next state
    output wire       out
);

    // State bits for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state logic (one-hot)
    // From table:
    // A: in=0->A, in=1->B
    // B: in=0->C, in=1->B
    // C: in=0->A, in=1->D
    // D: in=0->C, in=1->B

    assign next_state[0] = (A & ~in) | (C & ~in);       // A next when (A & in=0) or (C & in=0)
    assign next_state[1] = (A & in)  | (B & in) | (D & in); // B next when (A & in=1) or (B & in=1) or (D & in=1)
    assign next_state[2] = (B & ~in) | (D & ~in);       // C next when (B & in=0) or (D & in=0)
    assign next_state[3] = (C & in);                     // D next when (C & in=1)

    // Output logic: only D outputs 1
    assign out = D;

endmodule