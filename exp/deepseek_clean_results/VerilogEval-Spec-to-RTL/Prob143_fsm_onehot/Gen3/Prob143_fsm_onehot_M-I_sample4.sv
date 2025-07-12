module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

always @(*) begin
    // Initialize next_state to 0
    next_state = 10'b0;
    
    // Priority-based state transitions (higher states have priority)
    if (|state[9:7]) begin
        // Handle S7-S9 first (highest priority)
        if (state[7]) begin // S7
            next_state[0] = ~in;
            next_state[7] = in;
        end
        else if (state[8]) begin // S8
            next_state[0] = ~in;
            next_state[1] = in;
        end
        else if (state[9]) begin // S9
            next_state[0] = ~in;
            next_state[1] = in;
        end
    end
    else if (|state[6:5]) begin
        // Handle S5-S6 next
        if (state[5]) begin // S5
            next_state[8] = ~in;
            next_state[6] = in;
        end
        else if (state[6]) begin // S6
            next_state[9] = ~in;
            next_state[7] = in;
        end
    end
    else if (|state[4:0]) begin
        // Handle S0-S4 last
        if (|state[4:1]) begin
            // S1-S4 share similar transition patterns
            next_state[0] = ~in;
            if (state[1]) next_state[2] = in;
            if (state[2]) next_state[3] = in;
            if (state[3]) next_state[4] = in;
            if (state[4]) next_state[5] = in;
        end
        else if (state[0]) begin // S0
            next_state[0] = ~in;
            next_state[1] = in;
        end
    end
    
    // Output logic remains the same (already optimal)
    out1 = state[8] | state[9];  // S8 or S9
    out2 = state[7] | state[9];  // S7 or S9
end

endmodule