module TopModule (
    input  [5:0] y, // One-hot encoded current state: A=000001 y[0], B=000010 y[1], ...
    input        w,
    output       Y1, // Next-state signal corresponding to y[1] (state B)
    output       Y3  // Next-state signal corresponding to y[3] (state D)
);

// Next state B (y[1]) = from A (y[0]) on input w=0
assign Y1 = y[0] & ~w;

// Next state D (y[3]) = from B, C, E, F (y[1], y[2], y[4], y[5]) on input w=1
assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule