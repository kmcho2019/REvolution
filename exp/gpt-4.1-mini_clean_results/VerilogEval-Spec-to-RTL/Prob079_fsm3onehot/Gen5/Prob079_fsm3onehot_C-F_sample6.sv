module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // State bit aliases for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Inverted input for condition clarity
    wire in_not = ~in;

    // Next state logic with factored minimal expressions
    assign next_state[0] = in_not & (A | C);            // Next state A: in=0 and (A or C)
    assign next_state[1] = in     & (A | B | D);         // Next state B: in=1 and (A or B or D)
    assign next_state[2] = in_not & (B | D);            // Next state C: in=0 and (B or D)
    assign next_state[3] = in     & C;                   // Next state D: in=1 and C

    // Output logic: output=1 only in state D
    assign out = D;

endmodule