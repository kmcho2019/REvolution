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

    // next_state[0] = A or C when in=0
    assign next_state[0] = ~in & (A | C);

    // next_state[1] = B (hold) or from A or D when in=1
    assign next_state[1] = B | (in & (A | D));

    // next_state[2] = B or D when in=0
    assign next_state[2] = ~in & (B | D);

    // next_state[3] = from C when in=1
    assign next_state[3] = in & C;

    assign out = D;

endmodule