module TopModule(
    input  in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Initialize the next state to all zeros
assign next_state = 10'b0;
assign out1 = 1'b0;
assign out2 = 1'b0;

// Check for all possible states
always @(*)
begin
    // Check if any state is active
    if (state[0]) // S0
    begin
        if (!in) // 0
        begin
            next_state[0] = 1'b1; // Stay in S0
        end
        else // 1
        begin
            next_state[1] = 1'b1; // Go to S1
        end
    end
    if (state[1]) // S1
    begin
        if (!in) // 0
        begin
            next_state[0] = 1'b1; // Go to S0
        end
        else // 1
        begin
            next_state[2] = 1'b1; // Go to S2
        end
    end
    if (state[2]) // S2
    begin
        if (!in) // 0
        begin
            next_state[0] = 1'b1; // Go to S0
        end
        else // 1
        begin
            next_state[3] = 1'b1; // Go to S3
        end
    end
    if (state[3]) // S3
    begin
        if (!in) // 0
        begin
            next_state[0] = 1'b1; // Go to S0
        end
        else // 1
        begin
            next_state[4] = 1'b1; // Go to S4
        end
    end
    if (state[4]) // S4
    begin
        if (!in) // 0
        begin
            next_state[0] = 1'b1; // Go to S0
        end
        else // 1
        begin
            next_state[5] = 1'b1; // Go to S5
        end
    end
    if (state[5]) // S5
    begin
        if (!in) // 0
        begin
            next_state[8] = 1'b1; // Go to S8
        end
        else // 1
        begin
            next_state[6] = 1'b1; // Go to S6
        end
    end
    if (state[6]) // S6
    begin
        if (!in) // 0
        begin
            next_state[9] = 1'b1; // Go to S9
        end
        else // 1
        begin
            next_state[7] = 1'b1; // Go to S7
        end
    end
    if (state[7]) // S7
    begin
        if (!in) // 0
        begin
            next_state[0] = 1'b1; // Go to S0
        end
        else // 1
        begin
            next_state[7] = 1'b1; // Stay in S7
            out1 = 1'b1; // Set out1 to 1
        end
        out1 = 1'b1; // Set out1 to 1
    end
    if (state[8]) // S8
    begin
        if (!in) // 0
        begin
            next_state[0] = 1'b1; // Go to S0
        end
        else // 1
        begin
            next_state[1] = 1'b1; // Go to S1
        end
        out2 = 1'b1; // Set out2 to 0 and out1 to 1
    end
    if (state[9]) // S9
    begin
        if (!in) // 0
        begin
            next_state[0] = 1'b1; // Go to S0
        end
        else // 1
        begin
            next_state[1] = 1'b1; // Go to S1
        end
        out1 = 1'b1; // Set out1 to 1
        out2 = 1'b1; // Set out2 to 1
    end
end

endmodule