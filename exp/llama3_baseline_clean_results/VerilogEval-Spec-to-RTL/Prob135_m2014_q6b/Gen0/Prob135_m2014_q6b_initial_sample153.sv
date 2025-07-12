module TopModule(
    input [2:0] y,  // current state
    input w,      // input
    output Y1     // output y[1]
);

// next-state logic for y[1]
assign Y1 = ((~y[2] & ~y[1] & ~y[0] & ~w) |  // A to B
           (~y[2] & ~y[1] & y[0] & ~w) |    // A to B
           (~y[2] & y[1] & ~y[0] & w) |    // B to D
           (~y[2] & y[1] & y[0] & w) |    // C to D
           (~y[2] & y[1] & y[0] & ~w) |   // C to D
           (y[2] & ~y[1] & y[0] & ~w) |   // D to F
           (y[2] & y[1] & ~y[0] & ~w) |   // E to D
           (y[2] & y[1] & y[0] & ~w));    // F to D

endmodule