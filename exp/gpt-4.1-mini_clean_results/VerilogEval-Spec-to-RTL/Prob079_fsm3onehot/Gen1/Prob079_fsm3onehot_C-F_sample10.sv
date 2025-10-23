module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // One-hot state bit aliases for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state logic with factored terms for clarity and slight optimization
    assign next_state[0] = (A | C) & ~in;               // Next state A when in=0 from A or C
    assign next_state[1] = (A | B | D) & in;            // Next state B when in=1 from A, B, or D
    assign next_state[2] = (B | D) & ~in;               // Next state C when in=0 from B or D
    assign next_state[3] = C & in;                       // Next state D when in=1 from C

    // Output logic: output=1 only in state D
    assign out = D;

endmodule