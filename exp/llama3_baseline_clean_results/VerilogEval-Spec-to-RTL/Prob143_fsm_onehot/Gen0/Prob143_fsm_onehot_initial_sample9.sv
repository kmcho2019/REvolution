module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Calculate next state
always @(*) begin
    next_state = 10'b0000000000;
    if (state[0]) begin
        next_state[0] = ~in;
        next_state[1] = in;
    end
    if (state[1]) begin
        next_state[0] = ~in;
        next_state[2] = in;
    end
    if (state[2]) begin
        next_state[0] = ~in;
        next_state[3] = in;
    end
    if (state[3]) begin
        next_state[0] = ~in;
        next_state[4] = in;
    end
    if (state[4]) begin
        next_state[0] = ~in;
        next_state[5] = in;
    end
    if (state[5]) begin
        next_state[8] = ~in;
        next_state[6] = in;
    end
    if (state[6]) begin
        next_state[9] = ~in;
        next_state[7] = in;
    end
    if (state[7]) begin
        next_state[0] = ~in;
        next_state[7] = in;
    end
    if (state[8]) begin
        next_state[0] = ~in;
        next_state[1] = in;
    end
    if (state[9]) begin
        next_state[0] = ~in;
        next_state[1] = in;
    end
end

// Calculate outputs
always @(*) begin
    out1 = (state[7] || state[9]);
    out2 = (state[7] || state[8] || state[9]);
end

endmodule