module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

assign out1 = (state[7] && in) || (state[9] && in);
assign out2 = (state[7] && in) || (state[8]) || (state[9] && in);

always @(*) begin
    next_state = 10'b0;
    if (state[0] && !in) next_state[0] = 1'b1;
    if (state[0] && in) next_state[1] = 1'b1;
    if (state[1] && !in) next_state[0] = 1'b1;
    if (state[1] && in) next_state[2] = 1'b1;
    if (state[2] && !in) next_state[0] = 1'b1;
    if (state[2] && in) next_state[3] = 1'b1;
    if (state[3] && !in) next_state[0] = 1'b1;
    if (state[3] && in) next_state[4] = 1'b1;
    if (state[4] && !in) next_state[0] = 1'b1;
    if (state[4] && in) next_state[5] = 1'b1;
    if (state[5] && !in) next_state[8] = 1'b1;
    if (state[5] && in) next_state[6] = 1'b1;
    if (state[6] && !in) next_state[9] = 1'b1;
    if (state[6] && in) next_state[7] = 1'b1;
    if (state[7] && !in) next_state[0] = 1'b1;
    if (state[7] && in) next_state[7] = 1'b1;
    if (state[8] && !in) next_state[0] = 1'b1;
    if (state[8] && in) next_state[1] = 1'b1;
    if (state[9] && !in) next_state[0] = 1'b1;
    if (state[9] && in) next_state[1] = 1'b1;
end

endmodule