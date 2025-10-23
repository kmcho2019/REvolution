module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// For Y1, consider the states where y[1] will be 1 in the next state
// This includes transitions to B, D, and E
assign Y1 = (y[0] && w) || // A to B
            (y[1] && ~w) || // B to D
            (y[2] && ~w) || // C to D
            (y[3] && ~w) || // D to A (but since A has y[1]=0, this is not actually a transition to a state with y[1]=1)
            (y[4] && w) || // E to E
            (y[4] && ~w);  // E to D

// For Y3, consider the states where y[3] will be 1 in the next state
// This includes transitions to C, D, and F
assign Y3 = (y[1] && w) || // B to C
            (y[2] && ~w) || // C to D
            (y[3] && w) || // D to F
            (y[4] && ~w) || // E to D
            (y[5] && w);   // F to C

endmodule