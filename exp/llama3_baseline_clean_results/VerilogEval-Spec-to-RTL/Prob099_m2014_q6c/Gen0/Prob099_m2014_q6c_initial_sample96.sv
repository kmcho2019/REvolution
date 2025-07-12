module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Next-state logic for Y2 (y[1])
// State B is reached from state A when w is 1
assign Y2 = y[0] & w;

// Next-state logic for Y4 (y[3])
// State D is reached from states B, C, E, and F
assign Y4 = (y[1] & ~w) | (y[2] & ~w) | (y[4] & w) | (y[5] & w);

// Output logic
assign Y1 = y[0];
assign Y3 = y[2];

endmodule