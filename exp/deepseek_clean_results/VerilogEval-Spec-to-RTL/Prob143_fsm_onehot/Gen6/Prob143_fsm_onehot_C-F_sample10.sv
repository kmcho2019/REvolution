module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Precompute inverted input for efficiency
wire not_in = ~in;

// Output logic - continuous assignments
assign out1 = state[8] | state[9];  // Active in S8 or S9
assign out2 = state[7] | state[9];  // Active in S7 or S9

always @(*) begin
    next_state = 10'b0;
    
    // Handle states S0-S4 (similar transition patterns)
    if (|state[4:0]) begin
        next_state[0] = not_in;
        if (state[0]) next_state[1] = in;
        if (state[1]) next_state[2] = in;
        if (state[2]) next_state[3] = in;
        if (state[3]) next_state[4] = in;
        if (state[4]) next_state[5] = in;
    end
    
    // Handle unique states
    if (state[5]) begin // S5
        next_state[8] = not_in;
        next_state[6] = in;
    end
    if (state[6]) begin // S6
        next_state[9] = not_in;
        next_state[7] = in;
    end
    if (state[7]) begin // S7
        next_state[0] = not_in;
        next_state[7] = in;
    end
    
    // Handle S8 and S9 (shared transitions)
    if (|state[9:8]) begin
        next_state[0] = next_state[0] | not_in;
        next_state[1] = in;
    end
end

endmodule