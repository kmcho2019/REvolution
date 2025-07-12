module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // Extract current state bits
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state logic directly from transition table
    assign next_state[0] = (A & ~in) | (C & ~in); // A next when in=0 and in states A or C
    assign next_state[1] = (A & in) | (B & in) | (D & in); // B next when in=1 and in states A, B or D
    assign next_state[2] = (B & ~in) | (D & ~in); // C next when in=0 and in states B or D
    assign next_state[3] = C & in; // D next when in=1 and in state C

    // Output is 1 only in state D
    assign out = D;

endmodule