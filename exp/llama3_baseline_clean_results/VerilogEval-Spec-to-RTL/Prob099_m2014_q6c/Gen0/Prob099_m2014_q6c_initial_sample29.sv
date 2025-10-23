module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

assign Y1 = (y[1] && w) || (y[4] && w); // High in states B and E when w is 1
assign Y3 = (y[3] && ~w) || (y[1] && w) || (y[4] && ~w) || (y[5] && ~w); // High in state D or when transitioning to D

endmodule