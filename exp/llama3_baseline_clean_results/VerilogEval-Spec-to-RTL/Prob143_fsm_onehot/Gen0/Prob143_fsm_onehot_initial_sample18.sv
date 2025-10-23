module TopModule(
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
        next_state_reg = 10'b0;
        out1_reg = 1'b0;
        out2_reg = 1'b0;

        casez ({state, in})
            // S0
            {10'b0000000001, 1'b0}: begin
                next_state_reg[0] = 1'b1;
            end
            {10'b0000000001, 1'b1}: begin
                next_state_reg[1] = 1'b1;
            end

            // S1
            {10'b0000000010, 1'b0}: begin
                next_state_reg[0] = 1'b1;
            end
            {10'b0000000010, 1'b1}: begin
                next_state_reg[2] = 1'b1;
            end

            // S2
            {10'b0000000100, 1'b0}: begin
                next_state_reg[0] = 1'b1;
            end
            {10'b0000000100, 1'b1}: begin
                next_state_reg[3] = 1'b1;
            end

            // S3
            {10'b0000001000, 1'b0}: begin
                next_state_reg[0] = 1'b1;
            end
            {10'b0000001000, 1'b1}: begin
                next_state_reg[4] = 1'b1;
            end

            // S4
            {10'b0000010000, 1'b0}: begin
                next_state_reg[0] = 1'b1;
            end
            {10'b0000010000, 1'b1}: begin
                next_state_reg[5] = 1'b1;
            end

            // S5
            {10'b0000100000, 1'b0}: begin
                next_state_reg[8] = 1'b1;
            end
            {10'b0000100000, 1'b1}: begin
                next_state_reg[6] = 1'b1;
            end

            // S6
            {10'b0001000000, 1'b0}: begin
                next_state_reg[9] = 1'b1;
            end
            {10'b0001000000, 1'b1}: begin
                next_state_reg[7] = 1'b1;
            end

            // S7
            {10'b0010000000, 1'b0}: begin
                next_state_reg[0] = 1'b1;
            end
            {10'b0010000000, 1'b1}: begin
                next_state_reg[7] = 1'b1;
                out1_reg = 1'b0;
                out2_reg = 1'b1;
            end

            // S8
            {10'b0100000000, 1'b0}: begin
                next_state_reg[0] = 1'b1;
            end
            {10'b0100000000, 1'b1}: begin
                next_state_reg[1] = 1'b1;
                out1_reg = 1'b1;
                out2_reg = 1'b0;
            end

            // S9
            {10'b1000000000, 1'b0}: begin
                next_state_reg[0] = 1'b1;
            end
            {10'b1000000000, 1'b1}: begin
                next_state_reg[1] = 1'b1;
                out1_reg = 1'b1;
                out2_reg = 1'b1;
            end

            default: begin
                next_state_reg[0] = 1'b1;
            end
        endcase

        // handle the case where the input state is a combination of multiple states
        for (int i = 0; i < 10; i++) begin
            if (state[i]) begin
                case ({i, in})
                    5'b00000: next_state_reg[0] = 1'b1;
                    5'b00001: next_state_reg[1] = 1'b1;
                    5'b00010: next_state_reg[0] = 1'b1;
                    5'b00011: next_state_reg[2] = 1'b1;
                    5'b00100: next_state_reg[0] = 1'b1;
                    5'b00101: next_state_reg[3] = 1'b1;
                    5'b00110: next_state_reg[0] = 1'b1;
                    5'b00111: next_state_reg[4] = 1'b1;
                    5'b01000: next_state_reg[0] = 1'b1;
                    5'b01001: next_state_reg[5] = 1'b1;
                    5'b01010: next_state_reg[8] = 1'b1;
                    5'b01011: next_state_reg[6] = 1'b1;
                    5'b01100: next_state_reg[9] = 1'b1;
                    5'b01101: next_state_reg[7] = 1'b1;
                    5'b01110: next_state_reg[0] = 1'b1;
                    5'b01111: next_state_reg[7] = 1'b1;
                    5'b10000: next_state_reg[0] = 1'b1;
                    5'b10001: next_state_reg[1] = 1'b1;
                    5'b10010: next_state_reg[0] = 1'b1;
                    5'b10011: next_state_reg[1] = 1'b1;
                    5'b10100: next_state_reg[0] = 1'b1;
                    5'b10101: next_state_reg[1] = 1'b1;
                    5'b10110: next_state_reg[0] = 1'b1;
                    5'b10111: next_state_reg[1] = 1'b1;
                    5'b11000: next_state_reg[0] = 1'b1;
                    5'b11001: next_state_reg[1] = 1'b1;
                    5'b11010: next_state_reg[0] = 1'b1;
                    5'b11011: next_state_reg[1] = 1'b1;
                    5'b11100: next_state_reg[0] = 1'b1;
                    5'b11101: next_state_reg[1] = 1'b1;
                endcase
            end
        end

        // handle output
        for (int i = 0; i < 10; i++) begin
            if (state[i]) begin
                case ({i, in})
                    5'b00111: begin
                        out1_reg = 1'b0;
                        out2_reg = 1'b0;
                    end
                    5'b01001: begin
                        out1_reg = 1'b0;
                        out2_reg = 1'b0;
                    end
                    5'b01011: begin
                        out1_reg = 1'b0;
                        out2_reg = 1'b0;
                    end
                    5'b01101: begin
                        out1_reg = 1'b0;
                        out2_reg = 1'b1;
                    end
                    5'b01111: begin
                        out1_reg = 1'b0;
                        out2_reg = 1'b1;
                    end
                    5'b10001: begin
                        out1_reg = 1'b1;
                        out2_reg = 1'b0;
                    end
                    5'b10011: begin
                        out1_reg = 1'b1;
                        out2_reg = 1'b0;
                    end
                    5'b10101: begin
                        out1_reg = 1'b1;
                        out2_reg = 1'b1;
                    end
                    5'b10111: begin
                        out1_reg = 1'b1;
                        out2_reg = 1'b1;
                    end
                    5'b11001: begin
                        out1_reg = 1'b1;
                        out2_reg = 1'b0;
                    end
                    5'b11011: begin
                        out1_reg = 1'b1;
                        out2_reg = 1'b0;
                    end
                    5'b11101: begin
                        out1_reg = 1'b1;
                        out2_reg = 1'b1;
                    end
                    5'b11111: begin
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