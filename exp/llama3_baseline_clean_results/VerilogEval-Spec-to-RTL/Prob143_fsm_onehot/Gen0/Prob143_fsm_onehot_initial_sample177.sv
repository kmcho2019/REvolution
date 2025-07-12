module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Initialize next_state to zero
assign next_state = 10'b0;

// Initialize out1 and out2 to zero
assign out1 = 1'b0;
assign out2 = 1'b0;

// State transition logic
always @(*)
begin
    // S0
    if (state[0] == 1'b1)
    begin
        if (in == 1'b0)
            next_state[0] = 1'b1;
        else
            next_state[1] = 1'b1;
    end

    // S1
    if (state[1] == 1'b1)
    begin
        if (in == 1'b0)
            next_state[0] = 1'b1;
        else
            next_state[2] = 1'b1;
    end

    // S2
    if (state[2] == 1'b1)
    begin
        if (in == 1'b0)
            next_state[0] = 1'b1;
        else
            next_state[3] = 1'b1;
    end

    // S3
    if (state[3] == 1'b1)
    begin
        if (in == 1'b0)
            next_state[0] = 1'b1;
        else
            next_state[4] = 1'b1;
    end

    // S4
    if (state[4] == 1'b1)
    begin
        if (in == 1'b0)
            next_state[0] = 1'b1;
        else
            next_state[5] = 1'b1;
    end

    // S5
    if (state[5] == 1'b1)
    begin
        if (in == 1'b0)
            next_state[8] = 1'b1;
        else
            next_state[6] = 1'b1;
    end

    // S6
    if (state[6] == 1'b1)
    begin
        if (in == 1'b0)
            next_state[9] = 1'b1;
        else
            next_state[7] = 1'b1;
    end

    // S7
    if (state[7] == 1'b1)
    begin
        if (in == 1'b0)
            next_state[0] = 1'b1;
        else
            next_state[7] = 1'b1;
        out1 = in;
        out2 = in;
    end

    // S8
    if (state[8] == 1'b1)
    begin
        if (in == 1'b0)
            next_state[0] = 1'b1;
        else
            next_state[1] = 1'b1;
        out1 = 1'b1;
        out2 = 1'b0;
    end

    // S9
    if (state[9] == 1'b1)
    begin
        if (in == 1'b0)
            next_state[0] = 1'b1;
        else
            next_state[1] = 1'b1;
        out1 = 1'b1;
        out2 = 1'b1;
    end
end

endmodule