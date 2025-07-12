module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Next-state logic for Y1 (y[0])
assign Y1 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & y[0] & ~w);

// Next-state logic for Y3 (y[2])
assign Y3 = (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0] & ~w) | (y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & w);

endmodule