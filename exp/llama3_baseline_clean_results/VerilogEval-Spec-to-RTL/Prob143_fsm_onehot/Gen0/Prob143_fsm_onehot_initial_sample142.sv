module TopModule(
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

always @(*)
begin
    next_state = 10'b0; // Initialize next_state to 0
    out1 = 1'b0; // Initialize out1 to 0
    out2 = 1'b0; // Initialize out2 to 0

    // Check for each state in the current state
    if (state[0]) // S0
    begin
        if (!in)
            next_state[0] = 1'b1;
        else
            next_state[1] = 1'b1;
    end
    else if (state[1]) // S1
    begin
        if (!in)
            next_state[0] = 1'b1;
        else
            next_state[2] = 1'b1;
    end
    else if (state[2]) // S2
    begin
        if (!in)
            next_state[0] = 1'b1;
        else
            next_state[3] = 1'b1;
    end
    else if (state[3]) // S3
    begin
        if (!in)
            next_state[0] = 1'b1;
        else
            next_state[4] = 1'b1;
    end
    else if (state[4]) // S4
    begin
        if (!in)
            next_state[0] = 1'b1;
        else
            next_state[5] = 1'b1;
    end
    else if (state[5]) // S5
    begin
        if (!in)
            next_state[8] = 1'b1;
        else
            next_state[6] = 1'b1;
    end
    else if (state[6]) // S6
    begin
        if (!in)
            next_state[9] = 1'b1;
        else
            next_state[7] = 1'b1;
    end
    else if (state[7]) // S7
    begin
        if (!in)
            next_state[0] = 1'b1;
        else
            next_state[7] = 1'b1;
        out1 = 1'b1; // Set out1 to 1 for S7
        out2 = 1'b1; // Set out2 to 1 for S7
    end
    else if (state[8]) // S8
    begin
        if (!in)
            next_state[0] = 1'b1;
        else
            next_state[1] = 1'b1;
        out1 = 1'b1; // Set out1 to 1 for S8
    end
    else if (state[9]) // S9
    begin
        if (!in)
            next_state[0] = 1'b1;
        else
            next_state[1] = 1'b1;
        out1 = 1'b1; // Set out1 to 1 for S9
        out2 = 1'b1; // Set out2 to 1 for S9
    end
end

endmodule