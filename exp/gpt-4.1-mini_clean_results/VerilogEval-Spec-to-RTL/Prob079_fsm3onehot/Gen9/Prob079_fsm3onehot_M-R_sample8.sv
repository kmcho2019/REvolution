module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // Define one-hot state signals for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state for A: next_state[0] = (A & ~in) | (C & ~in)
    assign next_state[0] = (A & ~in) | (C & ~in);

    // Next state for B: next_state[1] = (A & in) | (B & in) | (D & in)
    assign next_state[1] = (A & in) | (B & in) | (D & in);

    // Next state for C: next_state[2] = (B & ~in) | (D & ~in)
    assign next_state[2] = (B & ~in) | (D & ~in);

    // Next state for D: next_state[3] = (C & in)
    assign next_state[3] = (C & in);

    // Output asserted only when in state D (one-hot)
    assign out = D;

endmodule