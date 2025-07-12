module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Priority-encoded state transition logic
    assign next_state = 
        state[3] ? (in ? 4'b0010 : 4'b0100) : // D transitions
        state[2] ? (in ? 4'b1000 : 4'b0001) : // C transitions
        state[1] ? (in ? 4'b0010 : 4'b0100) : // B transitions
        state[0] ? (in ? 4'b0010 : 4'b0001) : // A transitions
        4'b0001;                              // Default to A

    // Output logic remains optimal
    assign out = state[3];

endmodule