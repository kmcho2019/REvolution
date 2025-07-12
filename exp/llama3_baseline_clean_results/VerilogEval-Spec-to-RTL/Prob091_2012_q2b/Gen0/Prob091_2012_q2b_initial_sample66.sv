module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Y1 is 1 when the current state is A and w is 0
assign Y1 = ~y[5] & ~y[4] & ~y[3] & ~y[2] & y[1] & ~y[0] & ~w;

// Y3 is 1 when the current state is B, C, or E and w is 0, or when the current state is D and w is 1
assign Y3 = (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0] & ~w) |
           (~y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & ~w) |
           (y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & ~w) |
           (~y[5] & ~y[4] & ~y[3] & y[2] & ~y[1] & ~y[0] & w);

endmodule