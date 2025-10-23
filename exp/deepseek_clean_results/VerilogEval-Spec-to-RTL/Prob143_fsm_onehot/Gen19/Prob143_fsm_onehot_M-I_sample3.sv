module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Output logic remains efficient but more explicit
assign out1 = state[8] || state[9];  // S8 or S9
assign out2 = state[7] || state[9];  // S7 or S9

// Common signal
wire in_n = ~in;

always @(*) begin
    // Default all bits to 0 and handle transitions
    next_state = 10'b0;
    
    // S0 transitions
    if (state[0]) begin
        next_state[0] = in_n;
        next_state[1] = in;
    end
    
    // Separate S1-S4 for better timing
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
    
    // Combined S5 and S6 transitions
    if (state[5]) begin  // S5
        next_state[8] = in_n;
        next_state[6] = in;
    end
    if (state[6]) begin  // S6
        next_state[9] = in_n;
        next_state[7] = in;
    end
    
    // Simplified S7 transition
    if (state[7]) begin
        next_state[0] = in_n;
        next_state[7] = in;
    end
    
    // Separate S8 and S9 for better timing
    if (state[8]) begin  // S8
        next_state[0] = in_n;
        next_state[1] = in;
    end
    if (state[9]) begin  // S9
        next_state[0] = in_n;
        next_state[1] = in;
    end
end

endmodule