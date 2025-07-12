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
                case (i)
                    0, 1, 2, 3, 4: next_state_reg[in? i + 1 : 0] = 1'b1;
                    5: next_state_reg[in? 6 : 8] = 1'b1;
                    6: next_state_reg[in? 7 : 9] = 1'b1;
                    7: begin
                        next_state_reg[in? 7 : 0] = 1'b1; // S7
                        out2_reg = 1'b1;
                    end
                    8: begin
                        next_state_reg[in? 1 : 0] = 1'b1; // S8
                        out1_reg = 1'b1;
                    end
                    9: begin
                        next_state_reg[in? 1 : 0] = 1'b1; // S9
                        out1_reg = 1'b1;
                        out2_reg = 1'b1;
                    end
                    default: next_state_reg[0] = 1'b1; // Default state
                endcase
            end
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule