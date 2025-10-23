module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

// Next-state logic for Y1 (corresponding to state B)
assign Y1 = (y[0] && ~w) || (y[3] && ~w) || (y[5] && ~w);

// Next-state logic for Y2 (corresponding to state C)
assign Y2 = (y[1] && ~w) || (y[5] && ~w);

// Next-state logic for Y3 (corresponding to state D)
assign Y3 = (y[1] && w) || (y[2] && w) || (y[4] && w);

// Next-state logic for Y4 (corresponding to state E)
assign Y4 = (y[2] && w) || (y[4] && ~w);

endmodule