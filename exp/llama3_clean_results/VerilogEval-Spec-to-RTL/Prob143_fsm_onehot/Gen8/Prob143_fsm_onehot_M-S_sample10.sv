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
        next_state_reg = 10'b0; // Initialize next_state to zero
        out1_reg = 1'b0; // Initialize out1 to zero
        out2_reg = 1'b0; // Initialize out2 to zero

        // Handle states S0 to S4
        for (int i = 0; i <= 4; i++) begin
            if (state[i]) begin
                if (!in) begin
                    next_state_reg[0] = 1'b1;
                end else if (i < 4) begin
                    next_state_reg[i + 1] = 1'b1;
                end else begin
                    next_state_reg[5] = 1'b1;
                end
            end
        end

        // Handle state S5
        if (state[5]) begin
            if (!in) begin
                next_state_reg[8] = 1'b1;
            end else begin
                next_state_reg[6] = 1'b1;
            end
        end

        // Handle state S6
        if (state[6]) begin
            if (!in) begin
                next_state_reg[9] = 1'b1;
            end else begin
                next_state_reg[7] = 1'b1;
            end
        end

        // Handle states S7 to S9
        if (state[7]) begin
            if (!in) begin
                next_state_reg[0] = 1'b1;
            end else begin
                next_state_reg[7] = 1'b1;
            end
            out2_reg = 1'b1;
        end

        if (state[8]) begin
            if (!in) begin
                next_state_reg[0] = 1'b1;
            end else begin
                next_state_reg[1] = 1'b1;
            end
            out1_reg = 1'b1;
        end

        if (state[9]) begin
            if (!in) begin
                next_state_reg[0] = 1'b1;
            end else begin
                next_state_reg[1] = 1'b1;
            end
            out1_reg = 1'b1;
            out2_reg = 1'b1;
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule