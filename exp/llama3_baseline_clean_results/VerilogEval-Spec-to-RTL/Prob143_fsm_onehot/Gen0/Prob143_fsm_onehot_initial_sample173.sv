module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to 0
    assign next_state = 10'b0;

    // Initialize out1 and out2 to 0
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    // Determine next state and outputs based on current state and input
    always @(*) begin
        // Initialize next_state to 0
        next_state = 10'b0;

        // Initialize out1 and out2 to 0
        out1 = 1'b0;
        out2 = 1'b0;

        // Check if state S0 is active
        if (state[0] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Stay in S0
            end else begin
                next_state[1] = 1'b1; // Transition to S1
            end
        end

        // Check if state S1 is active
        if (state[1] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Transition to S0
            end else begin
                next_state[2] = 1'b1; // Transition to S2
            end
        end

        // Check if state S2 is active
        if (state[2] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Transition to S0
            end else begin
                next_state[3] = 1'b1; // Transition to S3
            end
        end

        // Check if state S3 is active
        if (state[3] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Transition to S0
            end else begin
                next_state[4] = 1'b1; // Transition to S4
            end
        end

        // Check if state S4 is active
        if (state[4] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Transition to S0
            end else begin
                next_state[5] = 1'b1; // Transition to S5
            end
        end

        // Check if state S5 is active
        if (state[5] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[8] = 1'b1; // Transition to S8
            end else begin
                next_state[6] = 1'b1; // Transition to S6
            end
        end

        // Check if state S6 is active
        if (state[6] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[9] = 1'b1; // Transition to S9
            end else begin
                next_state[7] = 1'b1; // Transition to S7
            end
        end

        // Check if state S7 is active
        if (state[7] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Transition to S0
            end else begin
                next_state[7] = 1'b1; // Stay in S7
                out2 = 1'b1;
            end
        end

        // Check if state S8 is active
        if (state[8] == 1'b1) begin
            out1 = 1'b1;
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Transition to S0
            end else begin
                next_state[1] = 1'b1; // Transition to S1
            end
        end

        // Check if state S9 is active
        if (state[9] == 1'b1) begin
            out1 = 1'b1;
            out2 = 1'b1;
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Transition to S0
            end else begin
                next_state[1] = 1'b1; // Transition to S1
            end
        end
    end

endmodule