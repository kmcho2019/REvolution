module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

always @(*) begin
    // Initialize next_state (outputs initialized only when needed)
    next_state = 10'b0;
    
    // Process each state with optimized transitions and outputs
    if (state[0]) begin // S0
        next_state[0] = ~in;
        next_state[1] = in;
        out1 = 0;
        out2 = 0;
    end
    if (state[1]) begin // S1
        next_state[0] = ~in;
        next_state[2] = in;
    end
    if (state[2]) begin // S2
        next_state[0] = ~in;
        next_state[3] = in;
    end
    if (state[3]) begin // S3
        next_state[0] = ~in;
        next_state[4] = in;
    end
    if (state[4]) begin // S4
        next_state[0] = ~in;
        next_state[5] = in;
    end
    if (state[5]) begin // S5
        next_state[8] = ~in;
        next_state[6] = in;
    end
    if (state[6]) begin // S6
        next_state[9] = ~in;
        next_state[7] = in;
    end
    if (state[7]) begin // S7
        next_state[0] = ~in;
        next_state[7] = in;
        out1 = 0;
        out2 = 1;
    end
    if (state[8]) begin // S8
        next_state[0] = ~in;
        next_state[1] = in;
        out1 = 1;
        out2 = 0;
    end
    if (state[9]) begin // S9
        next_state[0] = ~in;
        next_state[1] = in;
        out1 = 1;
        out2 = 1;
    end
end

endmodule