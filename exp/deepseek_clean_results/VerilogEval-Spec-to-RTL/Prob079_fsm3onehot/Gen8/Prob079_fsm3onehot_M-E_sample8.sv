module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Next state logic using priority-based selection
    assign next_state = 
        state[0] ? (in ? 4'b0010 : 4'b0001) :  // State A transitions
        state[1] ? (in ? 4'b0010 : 4'b0100) :  // State B transitions
        state[2] ? (in ? 4'b1000 : 4'b0001) :  // State C transitions
        state[3] ? (in ? 4'b0010 : 4'b0100) :  // State D transitions
        4'b0000;  // Default case (shouldn't occur with one-hot encoding)
    
    // Output is simply state D
    assign out = state[3];

endmodule