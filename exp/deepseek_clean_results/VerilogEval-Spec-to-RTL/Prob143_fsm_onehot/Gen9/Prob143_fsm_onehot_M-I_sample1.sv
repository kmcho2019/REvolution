module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

wire common_S0_transition = ~in;
wire common_S1_transition = in;

always @(*) begin
    next_state = 10'b0;
    
    // Handle all states in parallel
    if (|state[4:0]) begin // S0-S4 share common pattern
        next_state[0] = common_S0_transition;
        if (state[0]) next_state[1] = common_S1_transition;
        if (state[1]) next_state[2] = common_S1_transition;
        if (state[2]) next_state[3] = common_S1_transition;
        if (state[3]) next_state[4] = common_S1_transition;
        if (state[4]) next_state[5] = common_S1_transition;
    end
    
    if (state[5]) begin // S5
        next_state[8] = common_S0_transition;
        next_state[6] = common_S1_transition;
    end
    
    if (state[6]) begin // S6
        next_state[9] = common_S0_transition;
        next_state[7] = common_S1_transition;
    end
    
    if (state[7]) begin // S7
        next_state[0] = common_S0_transition;
        next_state[7] = common_S1_transition;
    end
    
    if (|state[9:8]) begin // S8 and S9 share same transitions
        next_state[0] = common_S0_transition;
        next_state[1] = common_S1_transition;
    end
end

// Optimized output logic - share state[9] term
wire special_state = |state[9:7];
assign out1 = state[8] | state[9];
assign out2 = (state[7] | state[9]) & special_state; // Added & special_state to prevent glitches

endmodule