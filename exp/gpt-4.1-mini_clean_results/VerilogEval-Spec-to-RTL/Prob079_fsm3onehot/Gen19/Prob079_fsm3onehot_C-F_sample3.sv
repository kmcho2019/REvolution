module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // One-hot state decoding for clarity and modularity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    wire in_n = ~in;

    // Factored next_state logic minimizes gate count and switching
    assign next_state[0] = (A | C) & in_n;           // Next state A: from A or C when in=0
    assign next_state[1] = (A | B | D) & in;          // Next state B: from A, B, or D when in=1
    assign next_state[2] = (B | D) & in_n;           // Next state C: from B or D when in=0
    assign next_state[3] = C & in;                    // Next state D: from C when in=1

    // Output is 1 only in state D (Moore output)
    assign out = D;

endmodule