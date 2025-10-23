module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Optimized output logic using continuous assignments
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

// Precompute common signals
wire in_n = ~in;

always @(*) begin
    // Initialize next_state to 0
    next_state = 10'b0;
    
    // Handle S0 transitions
    if (state[0]) begin
        next_state[0] = in_n;
        next_state[1] = in;
    end
    
    // Group S1-S4 which share similar transition patterns
    if (|state[4:1]) begin
        next_state[0] = next_state[0] | in_n;
        next_state[2] = state[1] & in;
        next_state[3] = state[2] & in;
        next_state[4] = state[3] & in;
        next_state[5] = state[4] & in;
    end
    
    // Handle S5 and S6 which have unique transitions
    if (state[5]) begin
        next_state[8] = in_n;
        next_state[6] = in;
    end
    if (state[6]) begin
        next_state[9] = in_n;
        next_state[7] = in;
    end
    
    // Handle S7 which has a self-loop
    if (state[7]) begin
        next_state[0] = next_state[0] | in_n;
        next_state[7] = in;
    end
    
    // Group S8 and S9 which share identical transitions
    if (|state[9:8]) begin
        next_state[0] = next_state[0] | in_n;
        next_state[1] = next_state[1] | in;
    end
end

endmodule