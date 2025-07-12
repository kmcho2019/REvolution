module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    // Current state bits for readability
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];
    wire in_n = ~in;

    // Next state logic with factoring for clarity and compactness
    assign next_state[0] = in_n & (A | C);       // Next state A: stay in A or go from C when in=0
    assign next_state[1] = in & (A | B | D);     // Next state B: from A, B, or D when in=1
    assign next_state[2] = in_n & (B | D);       // Next state C: from B or D when in=0
    assign next_state[3] = in & C;                // Next state D: from C when in=1

    // Output logic (Moore machine): output is 1 only in state D
    assign out = D;

endmodule