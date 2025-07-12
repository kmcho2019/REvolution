module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 is 1 when the next state is B or D
assign Y1 = (y[0] && w) || // A to B
             (y[1] && w) || // B to C (C doesn't set Y1, but this is for D, so it's actually B to D or C to D indirectly)
             (y[2] && ~w) || // C to D
             (y[4] && ~w) || // E to D
             (y[3] && w);   // D to F (F doesn't set Y1 directly, but D to F is considered for Y1 because of D)

// Y3 is 1 when the next state is C or D
assign Y3 = (y[1] && w) || // B to C
             (y[2] && ~w) || // C to D
             (y[3] && w) || // D to F (F doesn't directly set Y3, but for D to F, Y3 is set due to D)
             (y[5] && w);   // F to C

endmodule