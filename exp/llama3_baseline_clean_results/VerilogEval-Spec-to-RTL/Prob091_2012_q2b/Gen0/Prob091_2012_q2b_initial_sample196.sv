module TopModule(
    input [5:0] y, // current state
    input w,      // input signal
    output Y1,    // next state of y[1]
    output Y3     // next state of y[3]
);

// Next state logic for Y1
assign Y1 = (y[0] && w) || // A to B
           (y[1] && ~w) || // B to D
           (y[2] && ~w) || // C to D
           (y[3] && w) || // D to F, but F has y[5] = 1
           (y[4] && ~w);  // E to D

// Next state logic for Y3
assign Y3 = (y[1] && ~w) || // B to D
           (y[2] && ~w) || // C to D
           (y[3]);        // already in D

endmodule