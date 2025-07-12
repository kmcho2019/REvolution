module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    // State encoding: A=state[0], B=state[1], C=state[2], D=state[3]

    assign next_state[0] = (~in & state[0]) | (~in & state[2]);  // A if in=0 and in A or C
    assign next_state[1] = (in & state[0]) | (in & state[1]) | (in & state[3]); // B if in=1 and in A,B,D
    assign next_state[2] = (~in & state[1]) | (~in & state[3]);  // C if in=0 and in B or D
    assign next_state[3] = in & state[2];                        // D if in=1 and in C

    assign out = state[3];  // output is high only in state D

endmodule