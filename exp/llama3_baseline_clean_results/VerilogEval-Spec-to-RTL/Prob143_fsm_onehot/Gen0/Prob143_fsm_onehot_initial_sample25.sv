module TopModule (
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    reg [9:0] next_state_reg;
    reg out1_reg;
    reg out2_reg;

    always @(*) begin
        next_state_reg = 10'b0;  // Initialize next_state to zero
        out1_reg = 1'b0;         // Initialize out1 to zero
        out2_reg = 1'b0;         // Initialize out2 to zero

        // Apply state machine rules for each possible current state
        if (state[0] == 1'b1) begin  // S0
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1;  // Stay in S0
            end else begin
                next_state_reg[1] = 1'b1;  // Transition to S1
            end
        end

        if (state[1] == 1'b1) begin  // S1
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1;  // Transition to S0
            end else begin
                next_state_reg[2] = 1'b1;  // Transition to S2
            end
        end

        if (state[2] == 1'b1) begin  // S2
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1;  // Transition to S0
            end else begin
                next_state_reg[3] = 1'b1;  // Transition to S3
            end
        end

        if (state[3] == 1'b1) begin  // S3
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1;  // Transition to S0
            end else begin
                next_state_reg[4] = 1'b1;  // Transition to S4
            end
        end

        if (state[4] == 1'b1) begin  // S4
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1;  // Transition to S0
            end else begin
                next_state_reg[5] = 1'b1;  // Transition to S5
            end
        end

        if (state[5] == 1'b1) begin  // S5
            if (in == 1'b0) begin
                next_state_reg[8] = 1'b1;  // Transition to S8
            end else begin
                next_state_reg[6] = 1'b1;  // Transition to S6
            end
        end

        if (state[6] == 1'b1) begin  // S6
            if (in == 1'b0) begin
                next_state_reg[9] = 1'b1;  // Transition to S9
            end else begin
                next_state_reg[7] = 1'b1;  // Transition to S7
            end
        end

        if (state[7] == 1'b1) begin  // S7
            out2_reg = 1'b1;         // Set out2 to 1
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1;  // Transition to S0
            end else begin
                next_state_reg[7] = 1'b1;  // Stay in S7
            end
        end

        if (state[8] == 1'b1) begin  // S8
            out1_reg = 1'b1;         // Set out1 to 1
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1;  // Transition to S0
            end else begin
                next_state_reg[1] = 1'b1;  // Transition to S1
            end
        end

        if (state[9] == 1'b1) begin  // S9
            out1_reg = 1'b1;         // Set out1 to 1
            out2_reg = 1'b1;         // Set out2 to 1
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1;  // Transition to S0
            end else begin
                next_state_reg[1] = 1'b1;  // Transition to S1
            end
        end

        next_state = next_state_reg;
        out1 = out1_reg;
        out2 = out2_reg;
    end
endmodule