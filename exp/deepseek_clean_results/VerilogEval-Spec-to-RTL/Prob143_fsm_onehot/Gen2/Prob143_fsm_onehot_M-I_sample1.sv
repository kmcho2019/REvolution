module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

wire common_S0_transition;

// Common term for transition to S0 (used by many states)
assign common_S0_transition = ~in;

always @(*) begin
    next_state = 10'b0;
    
    // State transitions
    if (state[0]) begin // S0
        next_state[0] = common_S0_transition;
        next_state[1] = in;
    end
    if (state[1]) begin // S1
        next_state[0] = common_S0_transition;
        next_state[2] = in;
    end
    if (state[2]) begin // S2
        next_state[0] = common_S0_transition;
        next_state[3] = in;
    end
    if (state[3]) begin // S3
        next_state[0] = common_S0_transition;
        next_state[4] = in;
    end
    if (state[4]) begin // S4
        next_state[0] = common_S0_transition;
        next_state[5] = in;
    end
    if (state[5]) begin // S5
        next_state[8] = common_S0_transition;
        next_state[6] = in;
    end
    if (state[6]) begin // S6
        next_state[9] = common_S0_transition;
        next_state[7] = in;
    end
    if (state[7]) begin // S7
        next_state[0] = common_S0_transition;
        next_state[7] = in;
    end
    if (state[8]) begin // S8
        next_state[0] = common_S0_transition;
        next_state[1] = in;
    end
    if (state[9]) begin // S9
        next_state[0] = common_S0_transition;
        next_state[1] = in;
    end
end

// Optimized output logic
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

endmodule