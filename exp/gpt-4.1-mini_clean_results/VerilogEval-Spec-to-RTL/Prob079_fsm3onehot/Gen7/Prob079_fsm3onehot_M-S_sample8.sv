module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    // State encoding (one-hot):
    // A = state[0], B = state[1], C = state[2], D = state[3]

    assign next_state[0] = (~in & (state[0] | state[2])); // A
    assign next_state[1] = (in  & (state[0] | state[1] | state[3])); // B
    assign next_state[2] = (~in & (state[1] | state[3])); // C
    assign next_state[3] = (in  & state[2]);             // D

    assign out = state[3]; // output is high only in state D

endmodule