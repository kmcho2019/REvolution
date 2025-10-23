module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 is the input of state flip-flop y[1], which corresponds to state B
// State B is reached from state A when w = 1
assign Y1 = y[0] & w; // A (000001) and w = 1

// Y3 is the input of state flip-flop y[3], which corresponds to state D
// State D is reached from B when w = 0, from C when w = 0, from E when w = 0, and from F when w = 0
assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | (y[5] & ~w); // B, C, E, F and w = 0

endmodule