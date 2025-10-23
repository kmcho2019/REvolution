module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // next_state[A] = from A or C when in=0
    assign next_state[0] = (state[0] | state[2]) & ~in;

    // next_state[B] = from A, B, or D when in=1
    assign next_state[1] = (state[0] | state[1] | state[3]) & in;

    // next_state[C] = from B or D when in=0
    assign next_state[2] = (state[1] | state[3]) & ~in;

    // next_state[D] = from C when in=1
    assign next_state[3] = state[2] & in;

    // output is high only in state D
    assign out = state[3];

endmodule