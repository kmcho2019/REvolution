module TopModule(
    input [5:0] y,  // Current state (one-hot)
    input w,        // Input
    output Y1,      // Next state bit for state A (y[0])
    output Y3       // Next state bit for state D (y[3])
);

    // Full next state calculation
    wire [5:0] next_state;
    
    // State A transitions (y[0])
    assign next_state[0] = (y[0] & w) | (y[3] & w);
    
    // State B transitions (y[1])
    assign next_state[1] = y[0] & ~w;
    
    // State C transitions (y[2])
    assign next_state[2] = (y[1] & ~w) | (y[5] & ~w);
    
    // State D transitions (y[3])
    assign next_state[3] = (y[1] & w) | (y[2] & w) | (y[5] & w) | (y[4] & w);
    
    // State E transitions (y[4])
    assign next_state[4] = (y[2] & ~w) | (y[4] & ~w);
    
    // State F transitions (y[5])
    assign next_state[5] = y[3] & ~w;

    // Output the required bits
    assign Y1 = next_state[0];  // Next state for A
    assign Y3 = next_state[3];  // Next state for D

endmodule