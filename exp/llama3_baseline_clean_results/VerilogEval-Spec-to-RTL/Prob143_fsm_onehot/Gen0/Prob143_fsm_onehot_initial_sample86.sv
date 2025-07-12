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

        // Check for state S7
        if (state[7]) begin
            if (in) begin
                next_state_reg[7] = 1'b1;
            end else begin
                next_state_reg[0] = 1'b1;
            end
            out1_reg = 1'b0;
            out2_reg = 1'b1;
        end

        // Check for state S8
        else if (state[8]) begin
            if (in) begin
                next_state_reg[1] = 1'b1;
            end else begin
                next_state_reg[0] = 1'b1;
            end
            out1_reg = 1'b1;
            out2_reg = 1'b0;
        end

        // Check for state S9
        else if (state[9]) begin
            if (in) begin
                next_state_reg[1] = 1'b1;
            end else begin
                next_state_reg[0] = 1'b1;
            end
            out1_reg = 1'b1;
            out2_reg = 1'b1;
        end

        // Check for states S0-S6
        else begin
            // Check for states S0-S4
            if (state[0] || state[1] || state[2] || state[3] || state[4]) begin
                if (in) begin
                    if (state[0]) begin
                        next_state_reg[1] = 1'b1;
                    end else if (state[1]) begin
                        next_state_reg[2] = 1'b1;
                    end else if (state[2]) begin
                        next_state_reg[3] = 1'b1;
                    end else if (state[3]) begin
                        next_state_reg[4] = 1'b1;
                    end else if (state[4]) begin
                        next_state_reg[5] = 1'b1;
                    end
                end else begin
                    next_state_reg[0] = 1'b1;
                end
            end

            // Check for state S5
            if (state[5]) begin
                if (in) begin
                    next_state_reg[6] = 1'b1;
                end else begin
                    next_state_reg[8] = 1'b1;
                end
            end

            // Check for state S6
            if (state[6]) begin
                if (in) begin
                    next_state_reg[7] = 1'b1;
                end else begin
                    next_state_reg[9] = 1'b1;
                end
            end
        end

        next_state = next_state_reg;
        out1 = out1_reg;
        out2 = out2_reg;
    end

endmodule