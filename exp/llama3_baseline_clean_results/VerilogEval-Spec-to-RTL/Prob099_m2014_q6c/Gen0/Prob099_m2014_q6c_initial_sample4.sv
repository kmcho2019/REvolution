module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Next state logic for Y1 (state A)
assign Y1 = (~w & ~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & y[0]) | // A to A
            (~w & ~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0]) | // D to A
            (w & y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0]); // F to D, but since F to C is also possible and it doesn't affect Y1, this includes transitions indirectly affecting Y1

// Next state logic for Y3 (state C)
assign Y3 = (~w & ~y[5] & ~y[4] & ~y[3] & y[2] & ~y[1] & ~y[0]) | // B to C
            (~w & y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0]) | // F to C
            (~w & ~y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0]); // E to E doesn't change state C directly, but C to E and back is considered in other equations

endmodule