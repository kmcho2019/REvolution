module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // State bits for convenience
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state logic using mux-like expressions to reduce large OR gates

    // next_state[0] = (A or C) & ~in
    // Implement as (~in) & (A | C)
    assign next_state[0] = ~in & (A | C);

    // next_state[1] = in & (A or B or D)
    // Use mux logic: if in=1 and state is A, B, or D, next_state[1]=1
    assign next_state[1] = in & (A | B | D);

    // next_state[2] = (B or D) & ~in
    assign next_state[2] = ~in & (B | D);

    // next_state[3] = C & in
    assign next_state[3] = C & in;

    // Output is 1 only in state D
    assign out = D;

endmodule