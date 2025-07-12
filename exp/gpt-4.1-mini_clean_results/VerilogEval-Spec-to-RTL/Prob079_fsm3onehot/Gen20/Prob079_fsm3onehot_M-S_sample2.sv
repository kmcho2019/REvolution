module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    // next_state[0] (A): A or C when in=0
    assign next_state[0] = (~in) & (state[0] | state[2]);

    // next_state[1] (B): B or A or D when in=1
    assign next_state[1] = in & (state[0] | state[1] | state[3]);

    // next_state[2] (C): B or D when in=0
    assign next_state[2] = (~in) & (state[1] | state[3]);

    // next_state[3] (D): C when in=1
    assign next_state[3] = in & state[2];

    // output is high only in state D
    assign out = state[3];

endmodule