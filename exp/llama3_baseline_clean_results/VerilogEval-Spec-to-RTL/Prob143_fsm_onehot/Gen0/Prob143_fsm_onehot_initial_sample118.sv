module TopModule(
    input  in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Determine the next state based on the current state and input
    always @(*)
    begin
        next_state = 10'b0;  // Initialize next_state to 0
        out1 = 1'b0;  // Initialize out1 to 0
        out2 = 1'b0;  // Initialize out2 to 0

        if (state[0])  // State S0
        begin
            if (in)
                next_state[1] = 1'b1;  // Transition to S1
            else
                next_state[0] = 1'b1;  // Stay in S0
        end

        if (state[1])  // State S1
        begin
            if (in)
                next_state[2] = 1'b1;  // Transition to S2
            else
                next_state[0] = 1'b1;  // Transition to S0
        end

        if (state[2])  // State S2
        begin
            if (in)
                next_state[3] = 1'b1;  // Transition to S3
            else
                next_state[0] = 1'b1;  // Transition to S0
        end

        if (state[3])  // State S3
        begin
            if (in)
                next_state[4] = 1'b1;  // Transition to S4
            else
                next_state[0] = 1'b1;  // Transition to S0
        end

        if (state[4])  // State S4
        begin
            if (in)
                next_state[5] = 1'b1;  // Transition to S5
            else
                next_state[0] = 1'b1;  // Transition to S0
        end

        if (state[5])  // State S5
        begin
            if (in)
                next_state[6] = 1'b1;  // Transition to S6
            else
                next_state[8] = 1'b1;  // Transition to S8
        end

        if (state[6])  // State S6
        begin
            if (in)
                next_state[7] = 1'b1;  // Transition to S7
            else
                next_state[9] = 1'b1;  // Transition to S9
        end

        if (state[7])  // State S7
        begin
            if (in)
                next_state[7] = 1'b1;  // Stay in S7
            else
                next_state[0] = 1'b1;  // Transition to S0
            out1 = 1'b1;  // Set out1 to 1
            out2 = 1'b1;  // Set out2 to 1
        end

        if (state[8])  // State S8
        begin
            if (in)
                next_state[1] = 1'b1;  // Transition to S1
            else
                next_state[0] = 1'b1;  // Transition to S0
            out1 = 1'b1;  // Set out1 to 1
            out2 = 1'b0;  // Set out2 to 0
        end

        if (state[9])  // State S9
        begin
            if (in)
                next_state[1] = 1'b1;  // Transition to S1
            else
                next_state[0] = 1'b1;  // Transition to S0
            out1 = 1'b1;  // Set out1 to 1
            out2 = 1'b1;  // Set out2 to 1
        end
    end

endmodule