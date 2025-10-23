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

        // Iterate over each state bit and handle the specific state transitions and output logic
        for (int i = 0; i < 10; i++) begin
            if (state[i]) begin // Check each state individually
                case (i)
                    // States S0 to S4: transition to next state or S0 based on input
                    0, 1, 2, 3, 4: next_state_reg[!in? 0 : i + 1] = 1'b1;
                    // State S5: transition to S8 or S6 based on input
                    5: next_state_reg[!in? 8 : 6] = 1'b1;
                    // State S6: transition to S9 or S7 based on input
                    6: next_state_reg[!in? 9 : 7] = 1'b1;
                    // State S7: stay in S7 or transition to S0 based on input, and set out2
                    7: begin
                        next_state_reg[!in? 0 : 7] = 1'b1; // S7
                        out2_reg = 1'b1;
                    end
                    // State S8: transition to S0 or S1 based on input, and set out1
                    8: begin
                        next_state_reg[!in? 0 : 1] = 1'b1; // S8
                        out1_reg = 1'b1;
                    end
                    // State S9: transition to S0 or S1 based on input, and set out1 and out2
                    9: begin
                        next_state_reg[!in? 0 : 1] = 1'b1; // S9
                        out1_reg = 1'b1;
                        out2_reg = 1'b1;
                    end
                endcase
            end
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule