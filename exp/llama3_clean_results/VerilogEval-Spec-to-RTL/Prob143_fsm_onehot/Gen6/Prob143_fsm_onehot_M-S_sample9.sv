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

    integer i;

    always @(*) begin
        next_state_reg = 10'b0; // Initialize next_state to zero
        out1_reg = 1'b0; // Initialize out1 to zero
        out2_reg = 1'b0; // Initialize out2 to zero

        for (i = 0; i < 10; i++) begin
            if (state[i]) begin // Current state is set
                if (!in) begin // Input is 0
                    next_state_reg[0] = 1'b1; // Transition to S0
                end else begin // Input is 1
                    case (i)
                        0: next_state_reg[1] = 1'b1; // S0 -> S1
                        1: next_state_reg[2] = 1'b1; // S1 -> S2
                        2: next_state_reg[3] = 1'b1; // S2 -> S3
                        3: next_state_reg[4] = 1'b1; // S3 -> S4
                        4: next_state_reg[5] = 1'b1; // S4 -> S5
                        5: next_state_reg[6] = 1'b1; // S5 -> S6
                        6: next_state_reg[7] = 1'b1; // S6 -> S7
                        7: next_state_reg[7] = 1'b1; // S7 -> S7
                        8: next_state_reg[1] = 1'b1; // S8 -> S1
                        9: next_state_reg[1] = 1'b1; // S9 -> S1
                    endcase
                end
            end
        end

        // Output logic
        if (state[7] && in) begin // S7 and input is 1
            out2_reg = 1'b1;
        end
        if ((state[8] || state[9]) && (in || !in)) begin // S8 or S9
            out1_reg = 1'b1;
        end
        if (state[7] && in) begin // S7 and input is 1
            out2_reg = 1'b1;
        end
        if (state[9] && (in || !in)) begin // S9
            out2_reg = 1'b1;
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule