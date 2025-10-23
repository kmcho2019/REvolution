module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Output logic - active only in specific states
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

always @(*) begin
    next_state = 10'b0;  // Default all bits to 0
    
    // Handle all states that transition to S0 on 0
    if (|state[9:0] & ~in) next_state[0] = 1;
    
    // S0 specific transitions
    if (state[0] & in) next_state[1] = 1;
    
    // S1-S4 transitions (identical pattern)
    if ((|state[4:1]) & in) next_state[{state[4], state[3], state[2], state[1]} + 2] = 1;
    
    // S5 transitions
    if (state[5]) begin
        if (in) next_state[6] = 1;
        else next_state[8] = 1;
    end
    
    // S6 transitions
    if (state[6]) begin
        if (in) next_state[7] = 1;
        else next_state[9] = 1;
    end
    
    // S7 transitions (with self-loop)
    if (state[7] & in) next_state[7] = 1;
    
    // S8-S9 transitions (identical)
    if ((state[8] | state[9]) & in) next_state[1] = 1;
end

endmodule