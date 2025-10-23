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

    always @(*)
    begin
        next_state_reg = 10'b0;
        out1_reg = 1'b0;
        out2_reg = 1'b0;

        if (state[0]) // S0
        begin
            if (!in)
                next_state_reg[0] = 1'b1;
            else
                next_state_reg[1] = 1'b1;
        end
        else if (state[1]) // S1
        begin
            if (!in)
                next_state_reg[0] = 1'b1;
            else
                next_state_reg[2] = 1'b1;
        end
        else if (state[2]) // S2
        begin
            if (!in)
                next_state_reg[0] = 1'b1;
            else
                next_state_reg[3] = 1'b1;
        end
        else if (state[3]) // S3
        begin
            if (!in)
                next_state_reg[0] = 1'b1;
            else
                next_state_reg[4] = 1'b1;
        end
        else if (state[4]) // S4
        begin
            if (!in)
                next_state_reg[0] = 1'b1;
            else
                next_state_reg[5] = 1'b1;
        end
        else if (state[5]) // S5
        begin
            if (!in)
                next_state_reg[8] = 1'b1;
            else
                next_state_reg[6] = 1'b1;
        end
        else if (state[6]) // S6
        begin
            if (!in)
                next_state_reg[9] = 1'b1;
            else
                next_state_reg[7] = 1'b1;
        end
        else if (state[7]) // S7
        begin
            if (!in)
                next_state_reg[0] = 1'b1;
            else
                next_state_reg[7] = 1'b1;
            out1_reg = 1'b0;
            out2_reg = 1'b1;
        end
        else if (state[8]) // S8
        begin
            if (!in)
                next_state_reg[0] = 1'b1;
            else
                next_state_reg[1] = 1'b1;
            out1_reg = 1'b1;
            out2_reg = 1'b0;
        end
        else if (state[9]) // S9
        begin
            if (!in)
                next_state_reg[0] = 1'b1;
            else
                next_state_reg[1] = 1'b1;
            out1_reg = 1'b1;
            out2_reg = 1'b1;
        end
        else
        begin
            next_state_reg[0] = 1'b1;
        end

        next_state = next_state_reg;
        out1 = out1_reg;
        out2 = out2_reg;
    end

endmodule