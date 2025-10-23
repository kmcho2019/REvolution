module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // Decode current state bits for readability
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state logic directly by transitions
    assign next_state[0] = (A & ~in) | (C & ~in);    // A next when in=0 from A or C
    assign next_state[1] = (A & in) | (B & in) | (D & in); // B next when in=1 from A, B, or D
    assign next_state[2] = (B & ~in) | (D & ~in);    // C next when in=0 from B or D
    assign next_state[3] = C & in;                    // D next when in=1 from C

    // Output 1 only for state D
    assign out = D;

endmodule