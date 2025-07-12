module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // One-hot state encoding:
    // A = state[0], B = state[1], C = state[2], D = state[3]

    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    wire in_n = ~in;

    // Intermediate signals grouping states for common next_state logic
    wire AorC = A | C;         // Used in next_state[0]
    wire BorD = B | D;         // Used in next_state[2]
    wire AorBorD = A | B | D;  // Used in next_state[1]

    // Next state logic derived by inspection and factoring common terms
    assign next_state[0] = in_n & AorC;      // Next state A
    assign next_state[1] = in   & AorBorD;   // Next state B
    assign next_state[2] = in_n & BorD;      // Next state C
    assign next_state[3] = in   & C;          // Next state D

    // Moore machine output depends only on current state D
    assign out = D;

endmodule