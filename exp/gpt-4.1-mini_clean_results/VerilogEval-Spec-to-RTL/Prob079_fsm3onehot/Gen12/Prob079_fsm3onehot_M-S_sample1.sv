module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // State bits for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state logic - direct assignment without factoring
    assign next_state[0] = (A & ~in) | (C & ~in);  // Next A: from A or C when in=0
    assign next_state[1] = (A & in)  | (B & in)  | (D & in); // Next B: from A, B, D when in=1
    assign next_state[2] = (B & ~in) | (D & ~in);  // Next C: from B or D when in=0
    assign next_state[3] =  C & in;                 // Next D: from C when in=1

    // Output is 1 only in state D
    assign out = D;

endmodule