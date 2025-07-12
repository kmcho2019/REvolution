module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Next-state logic for Y1 (state B)
assign Y1 = (y[0] && !w); // Transition from A to B

// Next-state logic for Y3 (state D)
assign Y3 = (y[1] && w) || (y[2] && w) || (y[3] && !w) || (y[5] && w); 
// Transition from B to D, C to D, D to A (and then A to D), F to D

endmodule