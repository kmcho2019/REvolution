module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Initialize next state and outputs
assign next_state = 10'b0;
assign out1 = 1'b0;
assign out2 = 1'b0;

// Next state logic
always @(state, in) begin
    // Handle S0 transitions
    if (state[0]) begin
        if (!in) next_state[0] = 1'b1;
        else next_state[1] = 1'b1;
    end

    // Handle S1 transitions
    if (state[1]) begin
        if (!in) next_state[0] = 1'b1;
        else next_state[2] = 1'b1;
    end

    // Handle S2 transitions
    if (state[2]) begin
        if (!in) next_state[0] = 1'b1;
        else next_state[3] = 1'b1;
    end

    // Handle S3 transitions
    if (state[3]) begin
        if (!in) next_state[0] = 1'b1;
        else next_state[4] = 1'b1;
    end

    // Handle S4 transitions
    if (state[4]) begin
        if (!in) next_state[0] = 1'b1;
        else next_state[5] = 1'b1;
    end

    // Handle S5 transitions
    if (state[5]) begin
        if (!in) next_state[8] = 1'b1;
        else next_state[6] = 1'b1;
    end

    // Handle S6 transitions
    if (state[6]) begin
        if (!in) next_state[9] = 1'b1;
        else next_state[7] = 1'b1;
    end

    // Handle S7 transitions
    if (state[7]) begin
        if (!in) next_state[0] = 1'b1;
        else next_state[7] = 1'b1;
    end

    // Handle S8 transitions
    if (state[8]) begin
        if (!in) next_state[0] = 1'b1;
        else next_state[1] = 1'b1;
    end

    // Handle S9 transitions
    if (state[9]) begin
        if (!in) next_state[0] = 1'b1;
        else next_state[1] = 1'b1;
    end
end

// Output logic
always @(state, in) begin
    if (state[7] && in) begin
        out1 = 1'b0;
        out2 = 1'b1;
    end else if (state[8]) begin
        out1 = 1'b1;
        out2 = 1'b0;
    end else if (state[9]) begin
        out1 = 1'b1;
        out2 = 1'b1;
    end
end

endmodule