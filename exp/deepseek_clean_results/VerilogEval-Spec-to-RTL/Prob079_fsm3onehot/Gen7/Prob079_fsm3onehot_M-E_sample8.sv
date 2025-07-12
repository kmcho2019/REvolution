module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Priority-encoded state transition logic
    assign next_state = state[0] ? (in ? 4'b0010 : 4'b0001) :  // State A
                      state[1] ? (in ? 4'b0010 : 4'b0100) :    // State B
                      state[2] ? (in ? 4'b1000 : 4'b0001) :    // State C
                      state[3] ? (in ? 4'b0010 : 4'b0100) :    // State D
                      4'b0001;                                 // Default (shouldn't occur)

    // Output logic remains minimal
    assign out = state[3];

endmodule