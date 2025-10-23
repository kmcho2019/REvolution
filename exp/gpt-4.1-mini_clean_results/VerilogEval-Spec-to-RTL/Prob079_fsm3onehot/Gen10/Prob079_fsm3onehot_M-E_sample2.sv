module TopModule(
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);
    // State encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000

    wire in_n = ~in;

    assign next_state[0] = (state[0] & in_n) | (state[2] & in_n);
    assign next_state[1] = (state[0] & in)  | (state[1] & in)  | (state[3] & in);
    assign next_state[2] = (state[1] & in_n) | (state[3] & in_n);
    assign next_state[3] = state[2] & in;

    assign out = state[3];

endmodule