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

    // Factored next state logic leveraging one-hot property
    assign next_state[0] = (A | C) & ~in;           // Next A: from A or C when in=0
    assign next_state[1] = (A | B | D) & in;        // Next B: from A, B, or D when in=1
    assign next_state[2] = (B | D) & ~in;           // Next C: from B or D when in=0
    assign next_state[3] = C & in;                   // Next D: from C when in=1

    // Output is 1 only in state D (Moore output)
    assign out = D;

endmodule