module TopModule(
    input [5:0] y,  // One-hot encoded current state: y[0]=A, y[1]=B, ..., y[5]=F
    input w,
    output Y1,      // next y[0] (state A)
    output Y3       // next y[3] (state D)
);

    // Next state computation
    wire [5:0] next_state;
    
    // State A transitions
    assign next_state[0] = y[0] & w;  // Stay in A if w=1
    assign next_state[1] = y[0] & ~w; // Move to B if w=0
    
    // State B transitions
    assign next_state[2] = y[1] & ~w; // Move to C if w=0
    assign next_state[3] = y[1] & w;  // Move to D if w=1
    
    // State C transitions
    assign next_state[4] = y[2] & ~w; // Move to E if w=0
    assign next_state[3] = next_state[3] | (y[2] & w); // Also move to D if w=1
    
    // State D transitions
    assign next_state[5] = y[3] & ~w; // Move to F if w=0
    assign next_state[0] = next_state[0] | (y[3] & w); // Also move to A if w=1
    
    // State E transitions
    assign next_state[4] = next_state[4] | (y[4] & ~w); // Stay in E if w=0
    assign next_state[3] = next_state[3] | (y[4] & w);  // Move to D if w=1
    
    // State F transitions
    assign next_state[2] = next_state[2] | (y[5] & ~w); // Move to C if w=0
    assign next_state[3] = next_state[3] | (y[5] & w);  // Move to D if w=1
    
    // Output the required bits from next state
    assign Y1 = next_state[0];
    assign Y3 = next_state[3];

endmodule