module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Next-state logic for Y2 (state B)
assign Y2 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & y[0] & ~w);

// Next-state logic for Y4 (state D)
assign Y4 = (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0] & w) |
           (~y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & w) |
           (y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & w) |
           (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0] & w);

// Current state Y1 and Y3
assign Y1 = y[0];
assign Y3 = y[2];

endmodule