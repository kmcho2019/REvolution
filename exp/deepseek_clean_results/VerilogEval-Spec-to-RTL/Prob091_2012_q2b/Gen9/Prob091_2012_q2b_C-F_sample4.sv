module TopModule (
    input [5:0] y,  // One-hot encoded state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input w,        // State machine input
    output Y1,      // Next state for y[1] (state B)
    output Y3       // Next state for y[3] (state D)
);

    // Y1: Transition from A to B occurs when w=1
    // In one-hot: y[0] is A, and we move to B (y[1])
    assign Y1 = y[0] & w;

    // Y3: State D is entered from multiple states when w=0
    // From B (y[1]), C (y[2]), E (y[4]), or F (y[5]) when w=0
    // Optimized using one-hot property: ~(y[0] | y[3]) excludes A and current D state
    assign Y3 = ~w & ~(y[0] | y[3]);

endmodule