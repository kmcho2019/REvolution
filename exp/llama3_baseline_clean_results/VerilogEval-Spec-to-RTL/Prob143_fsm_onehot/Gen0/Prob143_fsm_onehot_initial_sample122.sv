module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    reg [9:0] next_state_reg;
    reg out1_reg;
    reg out2_reg;

    always @(*) begin
        next_state_reg = 10'b0; // Initialize next_state to 0
        out1_reg = 1'b0; // Initialize out1 to 0
        out2_reg = 1'b0; // Initialize out2 to 0

        // S0
        if (state[0] == 1'b1) begin
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1; // Stay in S0
            end else begin
                next_state_reg[1] = 1'b1; // Go to S1
            end
        end

        // S1
        if (state[1] == 1'b1) begin
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1; // Go to S0
            end else begin
                next_state_reg[2] = 1'b1; // Go to S2
            end
        end

        // S2
        if (state[2] == 1'b1) begin
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1; // Go to S0
            end else begin
                next_state_reg[3] = 1'b1; // Go to S3
            end
        end

        // S3
        if (state[3] == 1'b1) begin
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1; // Go to S0
            end else begin
                next_state_reg[4] = 1'b1; // Go to S4
            end
        end

        // S4
        if (state[4] == 1'b1) begin
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1; // Go to S0
            end else begin
                next_state_reg[5] = 1'b1; // Go to S5
            end
        end

        // S5
        if (state[5] == 1'b1) begin
            if (in == 1'b0) begin
                next_state_reg[8] = 1'b1; // Go to S8
            end else begin
                next_state_reg[6] = 1'b1; // Go to S6
            end
        end

        // S6
        if (state[6] == 1'b1) begin
            if (in == 1'b0) begin
                next_state_reg[9] = 1'b1; // Go to S9
            end else begin
                next_state_reg[7] = 1'b1; // Go to S7
            end
        end

        // S7
        if (state[7] == 1'b1) begin
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1; // Go to S0
            end else begin
                next_state_reg[7] = 1'b1; // Stay in S7
                out1_reg = 1'b0; // out1 = 0
                out2_reg = 1'b1; // out2 = 1
            end
        end

        // S8
        if (state[8] == 1'b1) begin
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1; // Go to S0
            end else begin
                next_state_reg[1] = 1'b1; // Go to S1
            end
            out1_reg = 1'b1; // out1 = 1
            out2_reg = 1'b0; // out2 = 0
        end

        // S9
        if (state[9] == 1'b1) begin
            if (in == 1'b0) begin
                next_state_reg[0] = 1'b1; // Go to S0
            end else begin
                next_state_reg[1] = 1'b1; // Go to S1
            end
            out1_reg = 1'b1; // out1 = 1
            out2_reg = 1'b1; // out2 = 1
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule