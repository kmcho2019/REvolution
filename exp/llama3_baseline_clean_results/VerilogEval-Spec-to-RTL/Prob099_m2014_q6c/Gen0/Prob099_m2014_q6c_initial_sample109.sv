module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Next-state logic for Y1 (y[1])
assign Y1 = (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0] & ~w) | // A to B
            (~y[5] & ~y[4] & ~y[3] & y[2] & ~y[1] & ~y[0] & ~w) | // A to B
            (~y[5] & ~y[4] & ~y[3] & ~y[2] & y[1] & ~y[0] & w) | // B to D
            (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0] & w) | // C to D
            (~y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & ~w) | // E to D
            (~y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & w); // E to D

// Next-state logic for Y3 (y[3])
assign Y3 = (~y[5] & ~y[4] & ~y[3] & y[2] & ~y[1] & ~y[0] & ~w) | // B to D
            (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0] & w) | // C to D
            (~y[5] & ~y[4] & ~y[3] & ~y[2] & y[1] & ~y[0] & ~w) | // D to F
            (~y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & w) | // E to D
            (y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & ~w); // F to C

endmodule