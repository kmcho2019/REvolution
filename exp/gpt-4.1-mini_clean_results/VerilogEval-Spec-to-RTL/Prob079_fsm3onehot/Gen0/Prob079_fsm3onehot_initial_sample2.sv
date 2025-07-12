module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // next_state bits (A, B, C, D)
    // From the table:
    // A next state when: 
    // - from A with in=0 => A
    // - from C with in=0 => A
    // B next state when:
    // - from A with in=1 => B
    // - from B with in=1 => B
    // - from D with in=1 => B
    // C next state when:
    // - from B with in=0 => C
    // - from D with in=0 => C
    // D next state when:
    // - from C with in=1 => D

    assign next_state[0] = (A & ~in) | (C & ~in);                // A
    assign next_state[1] = (A & in)  | (B & in)  | (D & in);     // B
    assign next_state[2] = (B & ~in) | (D & ~in);                // C
    assign next_state[3] = (C & in);                             // D

    // output is 1 only in state D
    assign out = D;

endmodule