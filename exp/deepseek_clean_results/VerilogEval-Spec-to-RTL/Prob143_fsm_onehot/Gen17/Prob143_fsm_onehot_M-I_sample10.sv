module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Common signals
wire in_n = ~in;
wire any_S1_S4 = |state[4:1];  // S1-S4 share similar transitions
wire any_S8_S9 = |state[9:8];  // S8-S9 share identical transitions

// Optimized output logic using bitmasking
assign out1 = |(state & 10'b1100000000);  // S8(1<<8) or S9(1<<9)
assign out2 = |(state & 10'b1001000000);  // S7(1<<7) or S9(1<<9)

always @(*) begin
    next_state = 10'b0;
    
    // Common transition to S0 for all states when in_n is true
    next_state[0] = in_n & |state;
    
    // Handle S0 transitions
    if (state[0]) begin
        next_state[1] = in;
    end
    
    // Group S1-S4 transitions (increment state on '1')
    if (any_S1_S4) begin
        case (1'b1)
            state[1]: next_state[2] = in;
            state[2]: next_state[3] = in;
            state[3]: next_state[4] = in;
            state[4]: next_state[5] = in;
        endcase
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
    
    // Handle S7 self-loop
    if (state[7]) begin
        next_state[7] = in;
    end
    
    // Group S8 and S9 transitions (both go to S1 on '1')
    if (any_S8_S9) begin
        next_state[1] = next_state[1] | in;
    end
end

endmodule