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
    out1 = 1'b0;
    out2 = 1'b0;

    // Handle each possible current state
    // S0 transitions
    if (state[0]) begin
        if (in) next_state[1] = 1'b1;
        else    next_state[0] = 1'b1;
    end

    // S1 transitions
    if (state[1]) begin
        if (in) next_state[2] = 1'b1;
        else    next_state[0] = 1'b1;
    end

    // S2 transitions
    if (state[2]) begin
        if (in) next_state[3] = 1'b1;
        else    next_state[0] = 1'b1;
    end

    // S3 transitions
    if (state[3]) begin
        if (in) next_state[4] = 1'b1;
        else    next_state[0] = 1'b1;
    end

    // S4 transitions
    if (state[4]) begin
        if (in) next_state[5] = 1'b1;
        else    next_state[0] = 1'b1;
    end

    // S5 transitions
    if (state[5]) begin
        if (in) next_state[6] = 1'b1;
        else    next_state[8] = 1'b1;
    end

    // S6 transitions
    if (state[6]) begin
        if (in) next_state[7] = 1'b1;
        else    next_state[9] = 1'b1;
    end

    // S7 transitions and outputs
    if (state[7]) begin
        out2 = 1'b1;
        if (in) next_state[7] = 1'b1;
        else    next_state[0] = 1'b1;
    end

    // S8 transitions and outputs
    if (state[8]) begin
        out1 = 1'b1;
        if (in) next_state[1] = 1'b1;
        else    next_state[0] = 1'b1;
    end

    // S9 transitions and outputs
    if (state[9]) begin
        out1 = 1'b1;
        out2 = 1'b1;
        if (in) next_state[1] = 1'b1;
        else    next_state[0] = 1'b1;
    end
end

endmodule