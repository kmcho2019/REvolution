module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    assign next_state[0] = (~in & (state[0] | state[2])); // A next on in=0 from A or C
    assign next_state[1] = (in & (state[0] | state[1] | state[3])); // B next on in=1 from A,B,D
    assign next_state[2] = (~in & (state[1] | state[3])); // C next on in=0 from B or D
    assign next_state[3] = (in & state[2]);              // D next on in=1 from C

    assign out = state[3]; // output=1 only in state D

endmodule