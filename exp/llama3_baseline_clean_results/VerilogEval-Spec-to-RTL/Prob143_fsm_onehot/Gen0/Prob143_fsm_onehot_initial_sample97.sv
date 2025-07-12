module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    always @(state, in) begin
        next_state = 10'b0000000000;
        out1 = 1'b0;
        out2 = 1'b0;

        if (state[0]) begin
            if (!in)
                next_state[0] = 1'b1;
            else
                next_state[1] = 1'b1;
        end

        if (state[1]) begin
            if (!in)
                next_state[0] = 1'b1;
            else
                next_state[2] = 1'b1;
        end

        if (state[2]) begin
            if (!in)
                next_state[0] = 1'b1;
            else
                next_state[3] = 1'b1;
        end

        if (state[3]) begin
            if (!in)
                next_state[0] = 1'b1;
            else
                next_state[4] = 1'b1;
        end

        if (state[4]) begin
            if (!in)
                next_state[0] = 1'b1;
            else
                next_state[5] = 1'b1;
        end

        if (state[5]) begin
            if (!in)
                next_state[8] = 1'b1;
            else
                next_state[6] = 1'b1;
        end

        if (state[6]) begin
            if (!in)
                next_state[9] = 1'b1;
            else
                next_state[7] = 1'b1;
        end

        if (state[7]) begin
            if (!in)
                next_state[0] = 1'b1;
            else
                next_state[7] = 1'b1;
            out1 = 1'b0;
            out2 = 1'b1;
        end

        if (state[8]) begin
            if (!in)
                next_state[0] = 1'b1;
            else
                next_state[1] = 1'b1;
            out1 = 1'b1;
            out2 = 1'b0;
        end

        if (state[9]) begin
            if (!in)
                next_state[0] = 1'b1;
            else
                next_state[1] = 1'b1;
            out1 = 1'b1;
            out2 = 1'b1;
        end
    end
endmodule