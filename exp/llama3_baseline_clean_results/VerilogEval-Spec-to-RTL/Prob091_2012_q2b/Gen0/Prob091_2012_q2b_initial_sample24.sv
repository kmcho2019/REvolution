module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Calculate next state flip-flop values based on current state and input
assign Y1 = (y[1] & ~w) | (y[0] & w);
assign Y3 = (y[2] & ~w) | (y[4] & w) | (y[5] & ~w);

endmodule