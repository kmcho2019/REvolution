module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

// Next-state logic for Y1 (y[1])
assign Y1 = (y[0] && w) || (y[2] && w) || (y[4] && w);

// Next-state logic for Y2 (y[2])
assign Y2 = (y[1] && ~w) || (y[2] && ~w) || (y[4] && ~w);

// Next-state logic for Y3 (y[3])
assign Y3 = (y[1] && w) || (y[2] && w) || (y[4] && w) || (y[5] && ~w);

// Next-state logic for Y4 (y[4])
assign Y4 = (y[2] && w) || (y[4] && w) || (y[5] && w);

endmodule