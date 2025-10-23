module TopModule(
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);
    // State encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000

    wire in_not = ~in;

    wire state_0_2   = state[0] | state[2];
    wire state_0_1_3 = state[0] | state[1] | state[3];
    wire state_1_3   = state[1] | state[3];

    // Next state logic (combinational)
    assign next_state[0] = in_not & state_0_2;
    assign next_state[1] = in & state_0_1_3;
    assign next_state[2] = in_not & state_1_3;
    assign next_state[3] = in & state[2];

    // Output logic (depends only on state D)
    assign out = state[3];

endmodule