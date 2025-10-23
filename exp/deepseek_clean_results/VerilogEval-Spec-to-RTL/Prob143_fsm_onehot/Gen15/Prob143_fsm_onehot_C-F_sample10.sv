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
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

always @(*) begin
    // Initialize all bits to 0
    next_state = 10'b0;
    
    // Common transition to S0
    wire to_S0 = in_n & (|state[1:4] | state[7] | |state[8:9]);
    
    // S0 transitions
    if (state[0]) begin
        next_state[0] = in_n;
        next_state[1] = in;
    end
    
    // S1-S4 transitions (grouped for efficiency)
    if (|state[1:4]) begin
        next_state[0] = to_S0;
        case (1'b1)
            state[1]: next_state[2] = in;
            state[2]: next_state[3] = in;
            state[3]: next_state[4] = in;
            state[4]: next_state[5] = in;
        endcase
    end
    
    // S5 transitions
    if (state[5]) begin
        next_state[8] = in_n;
        next_state[6] = in;
    end
    
    // S6 transitions
    if (state[6]) begin
        next_state[9] = in_n;
        next_state[7] = in;
    end
    
    // S7 transitions (with self-loop)
    if (state[7]) begin
        next_state[0] = to_S0;
        next_state[7] = in;
    end
    
    // S8-S9 transitions (grouped for efficiency)
    if (|state[8:9]) begin
        next_state[0] = to_S0;
        next_state[1] = in;
    end
end

endmodule