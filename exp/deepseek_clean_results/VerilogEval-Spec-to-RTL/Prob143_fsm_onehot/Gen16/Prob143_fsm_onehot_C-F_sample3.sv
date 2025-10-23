module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Optimized output logic with shared terms
wire s7_or_s9 = state[7] | state[9];
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = s7_or_s9;             // S7 or S9 (shares term with out1)

// Common signals
wire in_n = ~in;

always @(*) begin
    // Initialize all bits to 0
    next_state = 10'b0;
    
    // Handle S0 transitions
    if (state[0]) begin
        next_state[0] = in_n;
        next_state[1] = in;
    end
    
    // Group S1-S4 states (similar transitions)
    if (state[1] | state[2] | state[3] | state[4]) begin
        next_state[0] = next_state[0] | in_n;
        next_state[{state[4], state[3], state[2], state[1]}] = in;
    end
    
    // Handle S5 (unique transitions)
    if (state[5]) begin
        next_state[8] = in_n;
        next_state[6] = in;
    end
    
    // Handle S6 (unique transitions)
    if (state[6]) begin
        next_state[9] = in_n;
        next_state[7] = in;
    end
    
    // Handle S7 (self-loop)
    if (state[7]) begin
        next_state[0] = next_state[0] | in_n;
        next_state[7] = in;
    end
    
    // Group S8-S9 states (identical transitions)
    if (state[8] | state[9]) begin
        next_state[0] = next_state[0] | in_n;
        next_state[1] = next_state[1] | in;
    end
end

endmodule