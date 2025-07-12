module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Next state logic using priority-based approach
    
    // Y1: Next state for y[1] (state B)
    // Only transition is from A (y[0]) when w=1
    assign Y1 = y[0] & w;

    // Y3: Next state for y[3] (state D)
    // Transition to D occurs in these cases:
    // 1. From B (y[1]) when w=0
    // 2. From C (y[2]) when w=0
    // 3. From E (y[4]) when w=0
    // 4. From F (y[5]) when w=0
    // Implemented as parallel conditions for better timing
    wire transition_from_B = y[1] & ~w;
    wire transition_from_C = y[2] & ~w;
    wire transition_from_E = y[4] & ~w;
    wire transition_from_F = y[5] & ~w;
    
    assign Y3 = transition_from_B | transition_from_C | transition_from_E | transition_from_F;

endmodule