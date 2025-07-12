module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to zero, out1 to zero, and out2 to zero
    reg [9:0] next_state_reg;
    reg out1_reg;
    reg out2_reg;

    always @(*) begin
        // Reset next_state, out1, and out2
        next_state_reg = 10'b0; 
        out1_reg = 1'b0; 
        out2_reg = 1'b0; 

        // Loop over each state bit
        for (int i = 0; i < 10; i++) begin
            if (state[i]) begin // Check each state individually
                case (i)
                    // S0: transition to S0 if in is 0, otherwise transition to S1
                    0: next_state_reg[!in? 0 : 1] = 1'b1; 
                    // S1: transition to S0 if in is 0, otherwise transition to S2
                    1: next_state_reg[!in? 0 : 2] = 1'b1; 
                    // S2: transition to S0 if in is 0, otherwise transition to S3
                    2: next_state_reg[!in? 0 : 3] = 1'b1; 
                    // S3: transition to S0 if in is 0, otherwise transition to S4
                    3: next_state_reg[!in? 0 : 4] = 1'b1; 
                    // S4: transition to S0 if in is 0, otherwise transition to S5
                    4: next_state_reg[!in? 0 : 5] = 1'b1; 
                    // S5: transition to S8 if in is 0, otherwise transition to S6
                    5: next_state_reg[!in? 8 : 6] = 1'b1; 
                    // S6: transition to S9 if in is 0, otherwise transition to S7
                    6: next_state_reg[!in? 9 : 7] = 1'b1; 
                    // S7: transition to S0 if in is 0, otherwise stay in S7 and set out2 to 1
                    7: begin
                        next_state_reg[!in? 0 : 7] = 1'b1; 
                        out2_reg = 1'b1;
                    end
                    // S8: transition to S0 if in is 0, otherwise transition to S1 and set out1 to 1
                    8: begin
                        next_state_reg[!in? 0 : 1] = 1'b1; 
                        out1_reg = 1'b1;
                    end
                    // S9: transition to S0 if in is 0, otherwise transition to S1 and set out1 and out2 to 1
                    9: begin
                        next_state_reg[!in? 0 : 1] = 1'b1; 
                        out1_reg = 1'b1;
                        out2_reg = 1'b1;
                    end
                    // Default state: transition to S0
                    default: next_state_reg[0] = 1'b1; 
                endcase
            end
        end
    end

    // Assign next_state, out1, and out2
    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule