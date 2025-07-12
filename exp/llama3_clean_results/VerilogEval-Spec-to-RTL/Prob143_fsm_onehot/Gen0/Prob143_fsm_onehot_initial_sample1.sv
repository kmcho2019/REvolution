module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

always @(*) begin
    // Initialize next_state to all zeros
    next_state = 10'b0;
    
    // Initialize outputs to zero
    out1 = 1'b0;
    out2 = 1'b0;
    
    // Check for each possible state
    if (state[9]) begin // S9
        next_state[1] = in;
        next_state[0] = ~in;
        out1 = 1'b1;
        out2 = 1'b1;
    end else if (state[8]) begin // S8
        next_state[1] = in;
        next_state[0] = ~in;
        out1 = 1'b1;
        out2 = 1'b0;
    end else if (state[7]) begin // S7
        next_state[7] = in;
        next_state[0] = ~in;
        out1 = 1'b0;
        out2 = in;
    end else if (state[6]) begin // S6
        next_state[7] = in;
        next_state[9] = ~in;
        out1 = 1'b0;
        out2 = 1'b0;
    end else if (state[5]) begin // S5
        next_state[6] = in;
        next_state[8] = ~in;
        out1 = 1'b0;
        out2 = 1'b0;
    end else if (state[4]) begin // S4
        next_state[5] = in;
        next_state[0] = ~in;
        out1 = 1'b0;
        out2 = 1'b0;
    end else if (state[3]) begin // S3
        next_state[4] = in;
        next_state[0] = ~in;
        out1 = 1'b0;
        out2 = 1'b0;
    end else if (state[2]) begin // S2
        next_state[3] = in;
        next_state[0] = ~in;
        out1 = 1'b0;
        out2 = 1'b0;
    end else if (state[1]) begin // S1
        next_state[2] = in;
        next_state[0] = ~in;
        out1 = 1'b0;
        out2 = 1'b0;
    end else if (state[0]) begin // S0
        next_state[1] = in;
        next_state[0] = ~in;
        out1 = 1'b0;
        out2 = 1'b0;
    end
end

endmodule