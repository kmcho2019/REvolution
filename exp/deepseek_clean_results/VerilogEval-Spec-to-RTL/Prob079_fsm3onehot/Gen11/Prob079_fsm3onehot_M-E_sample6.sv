module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Priority-encoded state transition logic
    assign next_state[0] = state[0] ? (~in) : 
                         (state[1] ? (~in) : 
                         (state[2] ? (~in) : 
                         (state[3] ? 1'b0 : 1'b0)));

    assign next_state[1] = state[0] ? in : 
                         (state[1] ? in : 
                         (state[2] ? 1'b0 : 
                         (state[3] ? in : 1'b0)));

    assign next_state[2] = state[0] ? 1'b0 : 
                         (state[1] ? (~in) : 
                         (state[2] ? 1'b0 : 
                         (state[3] ? (~in) : 1'b0)));

    assign next_state[3] = state[0] ? 1'b0 : 
                         (state[1] ? 1'b0 : 
                         (state[2] ? in : 
                         (state[3] ? 1'b0 : 1'b0)));

    // Output logic remains unchanged
    assign out = state[3];

endmodule