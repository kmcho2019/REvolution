module TopModule (
    input       in,
    input [3:0] state,
    output[3:0] next_state,
    output      out
);
    assign next_state[0] = (~in & state[0]) | (~in & state[2]); // A: from A or C with in=0
    assign next_state[1] = (in & state[0]) | (in & state[1]) | (in & state[3]); // B: from A,B,D with in=1
    assign next_state[2] = (~in & state[1]) | (~in & state[3]); // C: from B,D with in=0
    assign next_state[3] = (in & state[2]); // D: from C with in=1
    assign out = state[3]; // output is 1 only in state D
endmodule