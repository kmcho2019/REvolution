module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Common inverted input signal
wire in_n = ~in;

// Output logic
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

always @(*) begin
    // Initialize all next_state bits to 0
    next_state = 10'b0;
    
    // Handle each state's transitions
    if (state[0]) begin  // S0
        next_state[0] = in_n;
        next_state[1] = in;
    end
    
    // Group S1-S4 as they share similar transition patterns
    if (state[1]) begin  // S1
        next_state[0] = in_n;
        next_state[2] = in;
    end
    if (state[2]) begin  // S2
        next_state[0] = in_n;
        next_state[3] = in;
    end
    if (state[3]) begin  // S3
        next_state[0] = in_n;
        next_state[4] = in;
    end
    if (state[4]) begin  // S4
        next_state[0] = in_n;
        next_state[5] = in;
    end
    
    // S5 and S6 have unique transitions
    if (state[5]) begin  // S5
        next_state[8] = in_n;
        next_state[6] = in;
    end
    if (state[6]) begin  // S6
        next_state[9] = in_n;
        next_state[7] = in;
    end
    
    // S7 has its own transition pattern
    if (state[7]) begin
        next_state[0] = in_n;
        next_state[7] = in;
    end
    
    // Combine identical S8 and S9 transitions
    if (state[8] | state[9]) begin
        next_state[0] = in_n;
        next_state[1] = in;
    end
end

endmodule