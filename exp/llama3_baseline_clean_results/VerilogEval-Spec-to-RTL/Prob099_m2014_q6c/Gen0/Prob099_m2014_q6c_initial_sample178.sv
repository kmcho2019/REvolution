module TopModule(
    input [5:0] y, // Current state
    input w, // Input signal
    output Y1, // Next-state signal for y[1]
    output Y3  // Next-state signal for y[3]
);

assign Y1 = (y[0] & ~w); // Next state for B (y[1]) is true if currently in A and w = 0
assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w); // Next state for D (y[3]) is true if transitioning from B, C, or E when w = 1

endmodule