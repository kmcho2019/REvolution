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

    // Next state logic
    assign next_state[0] = (A & ~in) | (C & ~in);     // Next state A
    assign next_state[1] = (A & in)  | (B & in) | (D & in);  // Next state B
    assign next_state[2] = (B & ~in) | (D & ~in);     // Next state C
    assign next_state[3] = (C & in);                   // Next state D

    // Output logic (Moore machine output depends only on current state)
    assign out = D;

endmodule