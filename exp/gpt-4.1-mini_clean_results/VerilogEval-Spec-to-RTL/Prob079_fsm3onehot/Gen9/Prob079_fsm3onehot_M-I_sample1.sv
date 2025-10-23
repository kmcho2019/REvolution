module TopModule(
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);
    // State encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000

    // Next state logic (combinational) using direct sum-of-products terms without intermediate ORs
    assign next_state[0] = (~in & state[0]) | (~in & state[2]);
    assign next_state[1] = (in & state[0])  | (in & state[1])  | (in & state[3]);
    assign next_state[2] = (~in & state[1]) | (~in & state[3]);
    assign next_state[3] = (in & state[2]);

    // Output depends only on state D
    assign out = state[3];

endmodule