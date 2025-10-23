module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Next state for y[1] (state B)
    // Only transitions from A (y[0]) when w=1
    // Direct implementation with minimal logic
    assign Y1 = y[0] & w;

    // Y3: Next state for y[3] (state D)
    // Active when:
    // 1. Not in state A (y[0]) or D (y[3])
    // 2. Input w is 0
    // Optimized by considering all states that can transition to D
    wire to_D_from_B = y[1] & ~w;
    wire to_D_from_C = y[2] & ~w;
    wire to_D_from_E = y[4] & ~w;
    wire to_D_from_F = y[5] & ~w;
    
    assign Y3 = to_D_from_B | to_D_from_C | to_D_from_E | to_D_from_F;

endmodule