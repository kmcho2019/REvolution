module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

assign out = (state == 2'b11); // Output 1 only in state D

assign next_state[1] = (state[0] & ~in) | (state[1] & in);
assign next_state[0] = in & ~(state == 2'b10 & ~in);

endmodule