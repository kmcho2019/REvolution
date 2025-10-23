module TopModule(
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);
    // State encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000

    // Factored next_state logic for better PPA
    wire in_n = ~in;

    assign next_state[0] = in_n & (state[0] | state[2]);
    assign next_state[1] = in   & (state[0] | state[1] | state[3]);
    assign next_state[2] = in_n & (state[1] | state[3]);
    assign next_state[3] = in   & state[2];

    // Output depends only on state D
    assign out = state[3];

endmodule