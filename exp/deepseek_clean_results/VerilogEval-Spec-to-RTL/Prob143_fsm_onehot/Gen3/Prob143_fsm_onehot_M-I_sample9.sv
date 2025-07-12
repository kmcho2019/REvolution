module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

wire transition_to_S0;

// Common transition to S0 logic
assign transition_to_S0 = (state[0] & ~in) | 
                         (state[1] & ~in) | 
                         (state[2] & ~in) | 
                         (state[3] & ~in) | 
                         (state[4] & ~in) | 
                         (state[5] & ~in) | 
                         (state[6] & ~in) | 
                         (state[7] & ~in) | 
                         (state[8] & ~in) | 
                         (state[9] & ~in);

always @(*) begin
    // Initialize next_state
    next_state = 10'b0;
    
    // Handle state transitions
    next_state[0] = transition_to_S0;
    next_state[1] = (state[0] & in) | (state[8] & in) | (state[9] & in);
    next_state[2] = state[1] & in;
    next_state[3] = state[2] & in;
    next_state[4] = state[3] & in;
    next_state[5] = state[4] & in;
    next_state[6] = state[5] & in;
    next_state[7] = (state[6] & in) | (state[7] & in);
    next_state[8] = state[5] & ~in;
    next_state[9] = state[6] & ~in;
end

// Separate always block for outputs to break critical path
always @(*) begin
    out1 = state[8] | state[9];
    out2 = state[7] | state[9];
end

endmodule