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

        for (int i = 0; i < 10; i++) begin
            if (state[i]) begin // Check each state individually
                if (i < 5) begin // S0 to S4
                    next_state_reg[!in? 0 : i + 1] = 1'b1;
                end else if (i == 5) begin // S5
                    next_state_reg[!in? 8 : 6] = 1'b1;
                end else if (i == 6) begin // S6
                    next_state_reg[!in? 9 : 7] = 1'b1;
                end else if (i == 7) begin // S7
                    next_state_reg[!in? 0 : 7] = 1'b1; // S7
                    out2_reg = 1'b1;
                end else if (i == 8) begin // S8
                    next_state_reg[!in? 0 : 1] = 1'b1; // S8
                    out1_reg = 1'b1;
                end else if (i == 9) begin // S9
                    next_state_reg[!in? 0 : 1] = 1'b1; // S9
                    out1_reg = 1'b1;
                    out2_reg = 1'b1;
                end
            end
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule