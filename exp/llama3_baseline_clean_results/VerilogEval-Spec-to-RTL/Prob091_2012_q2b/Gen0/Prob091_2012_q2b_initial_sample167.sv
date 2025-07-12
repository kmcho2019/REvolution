module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Y1 should be high for states that transition to B or D
assign Y1 = (y[0] & w) |  // A to B
            (y[1] & ~w) |  // B to D
            (y[2] & ~w) |  // C to D
            (y[4] & ~w) |  // E to D
            (y[5] & ~w);  // F to D

// Y3 should be high for states that transition to D
assign Y3 = (y[1] & ~w) |  // B to D
            (y[2] & ~w) |  // C to D
            (y[4] & ~w) |  // E to D
            (y[5] & ~w);  // F to D

endmodule