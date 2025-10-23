module TopModule(
    input [5:0] y,  // One-hot encoded current state
    input w,        // Input
    output Y2,      // Next state y[2] (state C)
    output Y4       // Next state y[4] (state E)
);

    // Next state vector (6 bits)
    wire [5:0] next_state;

    // State transition lookup table
    assign next_state = 
        y[0] ? (w ? 6'b000001 : 6'b000010) : // State A transitions
        y[1] ? (w ? 6'b001000 : 6'b000100) : // State B transitions
        y[2] ? (w ? 6'b001000 : 6'b010000) : // State C transitions
        y[3] ? (w ? 6'b000001 : 6'b100000) : // State D transitions
        y[4] ? (w ? 6'b001000 : 6'b010000) : // State E transitions
        y[5] ? (w ? 6'b001000 : 6'b000100) : // State F transitions
        6'b000001;                           // Default to state A

    // Extract the required outputs from next state vector
    assign Y2 = next_state[2];
    assign Y4 = next_state[4];

endmodule