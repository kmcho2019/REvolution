module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Next state logic for Y1 (y[1])
assign Y1 = (y[0] && w) ||  // A to B
             (y[1] && ~w) ||  // B to D
             (y[2] && ~w) ||  // C to D
             (y[3] && ~w) ||  // D to D (not possible) but included for completeness
             (y[4] && ~w) ||  // E to D
             (y[5] && ~w);   // F to D

// Next state logic for Y3 (y[3])
assign Y3 = (y[1] && ~w) ||  // B to D
             (y[2] && ~w) ||  // C to D
             (y[4] && ~w) ||  // E to D
             (y[5] && ~w);   // F to D

endmodule