module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // One-hot state signals for readability
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Factor next_state logic for better PPA

    // next_state[0] = (A | C) & ~in
    assign next_state[0] = (A | C) & ~in;

    // next_state[1] = in & (A | B | D)
    assign next_state[1] = in & (A | B | D);

    // next_state[2] = (B | D) & ~in
    assign next_state[2] = (B | D) & ~in;

    // next_state[3] = C & in
    assign next_state[3] = C & in;

    // Output asserted only when in state D
    assign out = D;

endmodule