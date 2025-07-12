module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Precompute inverted input for efficiency
wire in_n = ~in;

// Output logic - continuous assignments
assign out1 = state[8] | state[9];  // S8 or S9 active
assign out2 = state[7] | state[9];  // S7 or S9 active

always @(*) begin
    // Initialize next_state to 0
    next_state = 10'b0;
    
    // Handle each state explicitly for clarity
    if (state[0]) begin // S0
        next_state[0] = in_n;
        next_state[1] = in;
    end
    
    // Group S1-S4 which share similar transition patterns
    if (state[1]) begin // S1
        next_state[0] = in_n;
        next_state[2] = in;
    end
    if (state[2]) begin // S2
        next_state[0] = in_n;
        next_state[3] = in;
    end
    if (state[3]) begin // S3
        next_state[0] = in_n;
        next_state[4] = in;
    end
    if (state[4]) begin // S4
        next_state[0] = in_n;
        next_state[5] = in;
    end
    
    // S5 and S6 have unique transitions
    if (state[5]) begin // S5
        next_state[8] = in_n;
        next_state[6] = in;
    end
    if (state[6]) begin // S6
        next_state[9] = in_n;
        next_state[7] = in;
    end
    
    // S7 transition
    if (state[7]) begin // S7
        next_state[0] = in_n;
        next_state[7] = in;
    end
    
    // Group S8 and S9 which share identical transitions
    if (state[8]) begin // S8
        next_state[0] = in_n;
        next_state[1] = in;
    end
    if (state[9]) begin // S9
        next_state[0] = in_n;
        next_state[1] = in;
    end
end

endmodule