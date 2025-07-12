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

    assign next_state[0] = (A | C) & ~in;      // Next A: A or C if in=0
    assign next_state[1] = in & (A | B | D);   // Next B: A, B or D if in=1
    assign next_state[2] = (B | D) & ~in;      // Next C: B or D if in=0
    assign next_state[3] = C & in;              // Next D: C if in=1

    assign out = D;

endmodule