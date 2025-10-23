module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

// One-hot check for simulation (will be optimized out in synthesis)
wire is_onehot = (state == 10'b0000000001) ||
                (state == 10'b0000000010) ||
                (state == 10'b0000000100) ||
                (state == 10'b0000001000) ||
                (state == 10'b0000010000) ||
                (state == 10'b0000100000) ||
                (state == 10'b0001000000) ||
                (state == 10'b0010000000) ||
                (state == 10'b0100000000) ||
                (state == 10'b1000000000);

always @(*) begin
    next_state = 10'b0;
    out1 = 1'b0;
    out2 = 1'b0;
    
    // Handle outputs first since they're simpler
    out1 = state[8] | state[9];
    out2 = state[7] | state[9];
    
    // State transitions
    if (state[0]) begin // S0
        next_state[0] = ~in;
        next_state[1] = in;
    end
    else if (state[1]) begin // S1
        next_state[0] = ~in;
        next_state[2] = in;
    end
    else if (state[2]) begin // S2
        next_state[0] = ~in;
        next_state[3] = in;
    end
    else if (state[3]) begin // S3
        next_state[0] = ~in;
        next_state[4] = in;
    end
    else if (state[4]) begin // S4
        next_state[0] = ~in;
        next_state[5] = in;
    end
    else if (state[5]) begin // S5
        next_state[8] = ~in;
        next_state[6] = in;
    end
    else if (state[6]) begin // S6
        next_state[9] = ~in;
        next_state[7] = in;
    end
    else if (state[7]) begin // S7
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

endmodule