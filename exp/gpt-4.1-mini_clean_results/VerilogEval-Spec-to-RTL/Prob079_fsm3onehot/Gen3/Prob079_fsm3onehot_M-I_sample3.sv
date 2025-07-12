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

    // Next state logic: one-hot next state assignments
    // A: from A or C when in=0
    assign next_state[0] = (~in) & (A | C);
    // B: from A, B, or D when in=1
    assign next_state[1] = in & (A | B | D);
    // C: from B or D when in=0
    assign next_state[2] = (~in) & (B | D);
    // D: from C when in=1
    assign next_state[3] = in & C;

    // Output logic: output=1 only in state D
    assign out = D;

endmodule