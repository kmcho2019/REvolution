module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    reg [9:0] next_state_reg;
    reg       out1_reg, out2_reg;
    integer   idx;

    always @* begin
        next_state_reg = 10'b0;
        out1_reg = 1'b0;
        out2_reg = 1'b0;

        // Iterate over all possible states and combine transitions and outputs
        for (idx = 0; idx < 10; idx = idx + 1) begin
            if (state[idx]) begin
                case (idx)
                    0: begin // S0
                        if (in == 0) next_state_reg[0] = 1'b1;
                        else         next_state_reg[1] = 1'b1;
                        // outputs (0,0)
                    end
                    1: begin // S1
                        if (in == 0) next_state_reg[0] = 1'b1;
                        else         next_state_reg[2] = 1'b1;
                    end
                    2: begin // S2
                        if (in == 0) next_state_reg[0] = 1'b1;
                        else         next_state_reg[3] = 1'b1;
                    end
                    3: begin // S3
                        if (in == 0) next_state_reg[0] = 1'b1;
                        else         next_state_reg[4] = 1'b1;
                    end
                    4: begin // S4
                        if (in == 0) next_state_reg[0] = 1'b1;
                        else         next_state_reg[5] = 1'b1;
                    end
                    5: begin // S5
                        if (in == 0) next_state_reg[8] = 1'b1;
                        else         next_state_reg[6] = 1'b1;
                    end
                    6: begin // S6
                        if (in == 0) next_state_reg[9] = 1'b1;
                        else         next_state_reg[7] = 1'b1;
                    end
                    7: begin // S7
                        if (in == 0) next_state_reg[0] = 1'b1;
                        else         next_state_reg[7] = 1'b1;
                        out2_reg = 1'b1;
                    end
                    8: begin // S8
                        if (in == 0) next_state_reg[0] = 1'b1;
                        else         next_state_reg[1] = 1'b1;
                        out1_reg = 1'b1;
                    end
                    9: begin // S9
                        if (in == 0) next_state_reg[0] = 1'b1;
                        else         next_state_reg[1] = 1'b1;
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