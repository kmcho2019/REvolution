module TopModule (
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Next state logic for Y1 (y[1])
assign Y1 = (y[0] && !w) ||  // From A to B
            (y[1] && !w) ||  // From B to D
            (y[2] && !w) ||  // From C to D
            (y[3] && w) ||  // From D to F (not needed since F doesn't have y[1] = 1)
            (y[4] && !w);   // From E to D

// Next state logic for Y3 (y[3])
assign Y3 = (y[0] && !w) ||  // Not needed, A doesn't go to D directly
            (y[1] && !w) ||  // From B to D
            (y[2] && !w) ||  // From C to D
            (y[3] && !w) ||  // From D to A
            (y[4] && !w);   // From E to D

endmodule