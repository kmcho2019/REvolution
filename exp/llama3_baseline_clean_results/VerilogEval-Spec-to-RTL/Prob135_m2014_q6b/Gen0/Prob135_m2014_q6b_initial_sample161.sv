module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

// Next-state logic for y[1]
assign Y1 = ((~y[2] & ~y[1] & ~y[0] & w) |  // A -> B
            (~y[2] & y[1] & ~y[0] & w) |  // B -> D
            (~y[2] & ~y[1] & y[0] & w) |  // C -> D
            (y[2] & ~y[1] & ~y[0] & ~w) |  // D -> F
            (y[2] & y[1] & ~y[0] & ~w) |  // E -> D
            (y[2] & ~y[1] & y[0] & ~w));  // F -> D

endmodule