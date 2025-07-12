module TopModule(
    input  [5:0] y, // One-hot encoding of states A to F
    input  w,
    output Y1, // Next-state signal corresponding to state B (y[1])
    output Y3  // Next-state signal corresponding to state D (y[3])
);

// Logic equation for Y1 (next-state signal for state B)
assign Y1 = (y[0] && !w); // A transitions to B on w=0

// Logic equation for Y3 (next-state signal for state D)
assign Y3 = (y[1] && w) || (y[2] && w) || (y[4] && w) || (y[5] && w); 
// B, C, E, F transition to D on w=1

endmodule