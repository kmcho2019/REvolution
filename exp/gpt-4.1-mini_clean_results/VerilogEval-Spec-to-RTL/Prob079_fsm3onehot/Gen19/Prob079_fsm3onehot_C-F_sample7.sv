module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // One-hot current state decoding
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    wire not_in = ~in;

    // Factor common expressions to reduce gates and switching
    wire AB_D = A | B | D;
    wire B_D   = B | D;
    wire A_C   = A | C;

    // Next state logic derived from the FSM table
    assign next_state[0] = not_in & A_C;    // Next state A: from A or C if in=0
    assign next_state[1] = in     & AB_D;   // Next state B: from A, B, or D if in=1
    assign next_state[2] = not_in & B_D;    // Next state C: from B or D if in=0
    assign next_state[3] = in     & C;      // Next state D: from C if in=1

    // Moore output depends only on state D
    assign out = D;

endmodule