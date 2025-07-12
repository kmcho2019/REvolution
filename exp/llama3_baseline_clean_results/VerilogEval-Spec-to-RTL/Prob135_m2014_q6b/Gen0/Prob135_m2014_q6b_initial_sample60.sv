module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];

// Next state logic for y[1]
wire next_y1;
assign next_y1 = ((~y[2] & ~y[1] & ~y[0] & ~w) | // A to B
                 (~y[2] & y[1] & ~y[0] & w) | // B to D
                 (~y[2] & ~y[1] & y[0] & w) | // C to D
                 (y[2] & ~y[1] & ~y[0] & w) | // E to D
                 (~y[2] & y[1] & y[0] & ~w) | // D to F
                 (y[2] & y[1] & ~y[0] & ~w) | // F to C
                 (y[2] & y[1] & y[0] & w)); // F to D