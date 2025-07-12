module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Next-state signal Y1 (state B)
assign Y1 = (y[0] && ~w);

// Next-state signal Y3 (state D)
assign Y3 = (y[1] && w) || (y[2] && w) || (y[3] && ~w) || (y[4] && w) || (y[5] && ~w);

endmodule