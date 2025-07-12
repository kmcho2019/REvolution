module TopModule(
    input  [5:0] y,  // Current state
    input        w,  // Input signal
    output       Y1, // Next-state signal for y[1] (state B)
    output       Y3  // Next-state signal for y[3] (state D)
);

// Derive next-state signal Y1 (corresponding to state B)
// State B is entered from state A when w=1
assign Y1 = (y[0] && w);

// Derive next-state signal Y3 (corresponding to state D)
// State D is entered from states B, C, E, or F under specific conditions
assign Y3 = ((y[1] && ~w) || (y[2] && ~w) || (y[4] && w) || (y[5] && w));

endmodule