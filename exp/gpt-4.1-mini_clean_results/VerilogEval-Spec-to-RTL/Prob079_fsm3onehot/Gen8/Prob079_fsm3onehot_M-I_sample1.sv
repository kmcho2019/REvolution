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

    // Common terms
    wire any_ABD = A | B | D;    // for next_state[1]
    wire not_in = ~in;

    // Next state logic with factored expressions to reduce gate count
    assign next_state[0] = (A & not_in) | (C & not_in);   // Next state A = (A + C) & ~in
    assign next_state[1] = any_ABD & in;                   // Next state B = (A + B + D) & in
    assign next_state[2] = (B | D) & not_in;               // Next state C = (B + D) & ~in
    assign next_state[3] = C & in;                          // Next state D = C & in

    // Output logic (Moore machine output depends only on current state)
    assign out = D;

endmodule