module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 should be 1 when next state is B, D, E, or F
assign Y1 = (y[0] && w) || (y[1] && w) || (y[2] && w) || (y[4] && w) || (y[5] && w);

// Y3 should be 1 when next state is D, E, or F
assign Y3 = (y[0] && w) || (y[1] && ~w) || (y[2] && ~w) || (y[4] && ~w) || (y[5] && ~w);

endmodule