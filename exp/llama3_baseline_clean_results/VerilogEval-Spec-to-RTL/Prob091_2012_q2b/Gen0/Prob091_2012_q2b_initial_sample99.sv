module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Y1 should be '1' when the next state is B, which happens from state A when w is '0'
assign Y1 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & y[0] & ~w);

// Y3 should be '1' when the next state is D, which happens from states B, C, E, and F
// under certain conditions of w
assign Y3 = ((~y[5] & ~y[4] & y[3] & ~y[2] & y[1] & ~y[0] & ~w) |  // From B
             (~y[5] & y[4] & y[3] & ~y[2] & ~y[1] & ~y[0] & ~w) |  // From C
             (y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & ~w) |  // From E
             (y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & ~w)); // From F

endmodule