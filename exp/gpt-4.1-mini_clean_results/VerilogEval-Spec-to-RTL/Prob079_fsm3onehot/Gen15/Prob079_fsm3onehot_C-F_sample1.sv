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

    // Next state A: (A or C) when in=0 (factored)
    assign next_state[0] = (A | C) & ~in;

    // Next state B: explicit OR terms for clarity but factor in input=1 cases only
    // from A(in=1), B(in=1), D(in=1)
    assign next_state[1] = (A & in) | (B & in) | (D & in);

    // Next state C: (B or D) when in=0 (factored)
    assign next_state[2] = (B | D) & ~in;

    // Next state D: only from C(in=1), direct assignment for clarity
    assign next_state[3] = C & in;

    // Output = 1 only in state D (simple)
    assign out = D;

endmodule