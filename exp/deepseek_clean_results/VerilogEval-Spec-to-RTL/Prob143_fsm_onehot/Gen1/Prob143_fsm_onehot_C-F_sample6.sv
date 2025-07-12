module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

always @(*) begin
    // Initialize next_state to S0 by default (common case)
    next_state = 10'b0;
    next_state[0] = 1'b1;
    
    // Initialize outputs
    out1 = 1'b0;
    out2 = 1'b0;

    // Handle each state's transitions and outputs
    if (state[0]) begin // S0
        if (in) begin
            next_state = 10'b0;
            next_state[1] = 1'b1;
        end
    end
    else if (state[1]) begin // S1
        if (in) begin
            next_state = 10'b0;
            next_state[2] = 1'b1;
        end
    end
    else if (state[2]) begin // S2
        if (in) begin
            next_state = 10'b0;
            next_state[3] = 1'b1;
        end
    end
    else if (state[3]) begin // S3
        if (in) begin
            next_state = 10'b0;
            next_state[4] = 1'b1;
        end
    end
    else if (state[4]) begin // S4
        if (in) begin
            next_state = 10'b0;
            next_state[5] = 1'b1;
        end
    end
    else if (state[5]) begin // S5
        next_state = 10'b0;
        if (in) next_state[6] = 1'b1;
        else    next_state[8] = 1'b1;
    end
    else if (state[6]) begin // S6
        next_state = 10'b0;
        if (in) next_state[7] = 1'b1;
        else    next_state[9] = 1'b1;
    end
    else if (state[7]) begin // S7
        next_state = 10'b0;
        out2 = 1'b1;
        if (in) next_state[7] = 1'b1;
    end
    else if (state[8]) begin // S8
        next_state = 10'b0;
        out1 = 1'b1;
        if (in) next_state[1] = 1'b1;
    end
    else if (state[9]) begin // S9
        next_state = 10'b0;
        out1 = 1'b1;
        out2 = 1'b1;
        if (in) next_state[1] = 1'b1;
    end
end

endmodule