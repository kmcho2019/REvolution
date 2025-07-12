module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];
    wire in_n = ~in;

    assign next_state[0] = (A & in_n) | (C & in_n);    // Next A: from A or C when in=0
    assign next_state[1] = (A & in)   | (B & in) | (D & in); // Next B: from A, B, D when in=1
    assign next_state[2] = (B & in_n) | (D & in_n);    // Next C: from B or D when in=0
    assign next_state[3] = C & in;                      // Next D: from C when in=1

    assign out = D;  // Output high only in state D

endmodule