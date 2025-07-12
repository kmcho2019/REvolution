module TopModule(
    input [5:0] y, // One-hot encoded state
    input w, // Input that influences state transitions
    output Y1, // Next-state signal for state B (y[1])
    output Y3 // Next-state signal for state D (y[3])
);

// Determine next-state signals Y1 and Y3 based on current state and input w
assign Y1 = (y[0] && w) || (y[2] && !w); // State B is next when current state is A and w=1, or when current state is C and w=0
assign Y3 = (y[1] && !w) || (y[4] && !w) || (y[5] && w); // State D is next when current state is B and w=0, or when current state is E and w=0, or when current state is F and w=1

endmodule