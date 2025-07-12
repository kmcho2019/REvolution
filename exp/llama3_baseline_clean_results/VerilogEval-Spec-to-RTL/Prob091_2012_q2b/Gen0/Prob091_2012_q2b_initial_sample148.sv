module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Determine the next state based on the current state and input w
// Since we are only interested in Y1 and Y3, we only need to consider
// the bits y[1] and y[3] of the next state

// Y1 is 1 if the next state is B, D, or E
assign Y1 = (y[0] & w) |  // A to B
           (y[1] & ~w) |  // B to D
           (y[2] & ~w) |  // C to D
           (y[3] & w) |   // D to F
           (y[4] & w) |   // E to E
           (y[5] & ~w);   // F to D

// Y3 is 1 if the next state is C or F
assign Y3 = (y[1] & w) |  // B to C
           (y[5] & w);    // F to C

endmodule