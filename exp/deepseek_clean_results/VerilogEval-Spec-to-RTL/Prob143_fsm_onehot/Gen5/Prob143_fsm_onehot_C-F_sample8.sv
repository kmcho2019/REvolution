module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Precompute inverted input for efficiency
wire in_n = ~in;

// Output logic - continuous assignments (most efficient)
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

always @(*) begin
    // Initialize next_state to 0
    next_state = 10'b0;
    
    // Handle S0 transitions (unique)
    if (state[0]) begin
        next_state[0] = in_n;
        next_state[1] = in;
    end
    
    // Group S1-S4 transitions (similar pattern)
    if (|state[4:1]) begin
        next_state[0] = next_state[0] | in_n;
        next_state[{state[1], state[2], state[3], state[4]} & {4{in}}] = 1'b1;
    end
    
    // Handle S5 and S6 (unique transitions)
    if (state[5]) begin
        next_state[8] = in_n;
        next_state[6] = in;
    end
    if (state[6]) begin
        next_state[9] = in_n;
        next_state[7] = in;
    end
    
    // Handle S7 (self-loop)
    if (state[7]) begin
        next_state[0] = next_state[0] | in_n;
        next_state[7] = in;
    end
    
    // Group S8 and S9 (identical transitions)
    if (|state[9:8]) begin
        next_state[0] = next_state[0] | in_n;
        next_state[1] = next_state[1] | in;
    end
end

endmodule