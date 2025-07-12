module TopModule(
    input        in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output reg       out1,
    output reg       out2
);

always @(*) begin
    // Initialize outputs and next_state
    next_state = 10'b0;
    out1 = 1'b0;
    out2 = 1'b0;

    // S0 (0,0)
    if (state[0]) begin
        if (in == 1'b0)
            next_state[0] = 1'b1;
        else
            next_state[1] = 1'b1;
        // outputs (0,0) - no change
    end

    // S1 (0,0)
    if (state[1]) begin
        if (in == 1'b0)
            next_state[0] = 1'b1;
        else
            next_state[2] = 1'b1;
        // outputs (0,0)
    end

    // S2 (0,0)
    if (state[2]) begin
        if (in == 1'b0)
            next_state[0] = 1'b1;
        else
            next_state[3] = 1'b1;
        // outputs (0,0)
    end

    // S3 (0,0)
    if (state[3]) begin
        if (in == 1'b0)
            next_state[0] = 1'b1;
        else
            next_state[4] = 1'b1;
        // outputs (0,0)
    end

    // S4 (0,0)
    if (state[4]) begin
        if (in == 1'b0)
            next_state[0] = 1'b1;
        else
            next_state[5] = 1'b1;
        // outputs (0,0)
    end

    // S5 (0,0)
    if (state[5]) begin
        if (in == 1'b0)
            next_state[8] = 1'b1;
        else
            next_state[6] = 1'b1;
        // outputs (0,0)
    end

    // S6 (0,0)
    if (state[6]) begin
        if (in == 1'b0)
            next_state[9] = 1'b1;
        else
            next_state[7] = 1'b1;
        // outputs (0,0)
    end

    // S7 (0,1)
    if (state[7]) begin
        if (in == 1'b0)
            next_state[0] = 1'b1;
        else
            next_state[7] = 1'b1;
        // outputs (0,1)
        out2 = 1'b1;
    end

    // S8 (1,0)
    if (state[8]) begin
        if (in == 1'b0)
            next_state[0] = 1'b1;
        else
            next_state[1] = 1'b1;
        // outputs (1,0)
        out1 = 1'b1;
    end

    // S9 (1,1)
    if (state[9]) begin
        if (in == 1'b0)
            next_state[0] = 1'b1;
        else
            next_state[1] = 1'b1;
        // outputs (1,1)
        out1 = 1'b1;
        out2 = 1'b1;
    end
end

endmodule