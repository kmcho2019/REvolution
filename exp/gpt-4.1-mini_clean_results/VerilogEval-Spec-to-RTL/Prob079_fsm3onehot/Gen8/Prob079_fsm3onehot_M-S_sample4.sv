module TopModule(
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);
    // State encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000

    // Next state logic (combinational), only one bit active in state at a time
    assign next_state[0] = (state[0] & ~in) | (state[2] & ~in); // A next state: from A or C when in=0
    assign next_state[1] = (state[0] & in)  | (state[1] & in) | (state[3] & in); // B next state: from A, B or D when in=1
    assign next_state[2] = (state[1] & ~in) | (state[3] & ~in); // C next state: from B or D when in=0
    assign next_state[3] = (state[2] & in); // D next state: from C when in=1

    // Output logic (Moore output: only high in state D)
    assign out = state[3];

endmodule