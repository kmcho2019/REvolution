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

    // Next state logic with factored terms
    assign next_state[0] = ~in & (A | C);
    assign next_state[1] = in  & (A | B | D);
    assign next_state[2] = ~in & (B | D);
    assign next_state[3] = in  & C;

    // Output asserted only in state D
    assign out = D;

endmodule