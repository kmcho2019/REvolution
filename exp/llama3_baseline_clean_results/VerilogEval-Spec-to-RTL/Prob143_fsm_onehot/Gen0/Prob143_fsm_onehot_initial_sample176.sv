module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Initialize next_state with zeros
assign next_state = 10'b0;

// Generate next_state and outputs based on the current state and input
always @(*)
begin
    out1 = 1'b0;
    out2 = 1'b0;

    // Check for S7 state and input
    if (state[6] && in)
    begin
        next_state[6] = 1'b1; // Stay in S7
        out1 = 1'b0;
        out2 = 1'b1;
    end
    else if (state[6] && !in)
    begin
        next_state[0] = 1'b1; // Transition to S0
    end

    // Check for S8 and S9 states
    if (state[8])
    begin
        next_state[0] = 1'b1; // Transition to S0 if input is 0
        out1 = 1'b1;
        out2 = 1'b0;
        if (in)
        begin
            next_state[1] = 1'b1; // Transition to S1 if input is 1
        end
    end
    else if (state[9])
    begin
        next_state[0] = 1'b1; // Transition to S0 if input is 0
        out1 = 1'b1;
        out2 = 1'b1;
        if (in)
        begin
            next_state[1] = 1'b1; // Transition to S1 if input is 1
        end
    end

    // Check for other states
    if (state[0] && in)
    begin
        next_state[1] = 1'b1; // Transition to S1
    end
    else if (state[1] && in)
    begin
        next_state[2] = 1'b1; // Transition to S2
    end
    else if (state[2] && in)
    begin
        next_state[3] = 1'b1; // Transition to S3
    end
    else if (state[3] && in)
    begin
        next_state[4] = 1'b1; // Transition to S4
    end
    else if (state[4] && in)
    begin
        next_state[5] = 1'b1; // Transition to S5
    end
    else if (state[5])
    begin
        if (in)
        begin
            next_state[6] = 1'b1; // Transition to S6
        end
        else
        begin
            next_state[8] = 1'b1; // Transition to S8
        end
    end
    else if (state[6])
    begin
        if (in)
        begin
            next_state[7] = 1'b1; // Transition to S7
        end
        else
        begin
            next_state[9] = 1'b1; // Transition to S9
        end
    end

    // If none of the above conditions match, transition to S0
    if (!next_state)
    begin
        next_state[0] = 1'b1;
    end
end

endmodule