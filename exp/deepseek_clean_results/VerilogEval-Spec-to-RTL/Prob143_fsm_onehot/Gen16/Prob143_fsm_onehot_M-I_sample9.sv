module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Optimized output logic - share state[9] term
wire s7_or_s9 = state[7] | state[9];
assign out1 = state[8] | state[9];
assign out2 = s7_or_s9;

always @(*) begin
    // Default all bits to 0 (optimized synthesis will handle this efficiently)
    next_state = 10'b0;
    
    // Common terms
    wire any_S1_S4 = |state[4:1];
    wire any_S8_S9 = |state[9:8];
    wire transition_to_S0 = ~in;
    wire transition_to_S1 = in;
    
    // S0 transitions
    if (state[0]) begin
        next_state[0] = transition_to_S0;
        next_state[1] = transition_to_S1;
    end
    
    // Combined S1-S4 handling
    if (any_S1_S4) begin
        next_state[0] = next_state[0] | transition_to_S0;
        next_state[{state[4], state[3], state[2], state[1]} + 2] = transition_to_S1;
    end
    
    // S5 transitions
    if (state[5]) begin
        next_state[8] = transition_to_S0;
        next_state[6] = transition_to_S1;
    end
    
    // S6 transitions
    if (state[6]) begin
        next_state[9] = transition_to_S0;
        next_state[7] = transition_to_S1;
    end
    
    // S7 transitions
    if (state[7]) begin
        next_state[0] = next_state[0] | transition_to_S0;
        next_state[7] = transition_to_S1;
    end
    
    // Combined S8-S9 handling
    if (any_S8_S9) begin
        next_state[0] = next_state[0] | transition_to_S0;
        next_state[1] = next_state[1] | transition_to_S1;
    end
end

endmodule