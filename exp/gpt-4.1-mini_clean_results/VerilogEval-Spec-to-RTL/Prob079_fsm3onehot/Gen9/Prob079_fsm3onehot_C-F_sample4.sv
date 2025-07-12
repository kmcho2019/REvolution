module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // One-hot state encoding for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state logic derived by inspection with minimal OR inputs:
    // next_state[0] (A): from A and C on in=0
    assign next_state[0] = (A & ~in) | (C & ~in);
    // next_state[1] (B): from A on in=1, from B on in=1, and from D on in=1
    assign next_state[1] = (A & in) | (B & in) | (D & in);
    // next_state[2] (C): from B and D on in=0
    assign next_state[2] = (B & ~in) | (D & ~in);
    // next_state[3] (D): from C on in=1
    assign next_state[3] = C & in;

    // Output is 1 only in state D (Moore output)
    assign out = D;

endmodule