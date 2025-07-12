module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Simplified output logic
    assign out = state[3];  // Output is '1' only when state is 'D' (4'b1000)

    // State transition logic using explicit assignments
    assign next_state = 
        (state == 4'b0001) ? (in ? 4'b0010 : 4'b0001) :  // State A transitions
        (state == 4'b0010) ? (in ? 4'b0010 : 4'b0100) :  // State B transitions
        (state == 4'b0100) ? (in ? 4'b1000 : 4'b0001) :  // State C transitions
        (state == 4'b1000) ? (in ? 4'b0010 : 4'b0100) :  // State D transitions
        4'bxxxx;  // Default value, should not occur with one-hot encoding

endmodule