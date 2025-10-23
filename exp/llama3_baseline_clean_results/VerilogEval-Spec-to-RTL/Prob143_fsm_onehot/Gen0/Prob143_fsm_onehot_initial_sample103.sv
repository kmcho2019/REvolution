module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state with zeros
    assign next_state = 10'b0000000000;

    // Initialize out1 and out2 with zeros
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    // Implement state transition logic
    always @(*)
    begin
        if (state[0]) // S0
        begin
            if (!in)
                next_state[0] = 1'b1;
            else
                next_state[1] = 1'b1;
        end

        if (state[1]) // S1
        begin
            if (!in)
                next_state[0] = 1'b1;
            else
                next_state[2] = 1'b1;
        end

        if (state[2]) // S2
        begin
            if (!in)
                next_state[0] = 1'b1;
            else
                next_state[3] = 1'b1;
        end

        if (state[3]) // S3
        begin
            if (!in)
                next_state[0] = 1'b1;
            else
                next_state[4] = 1'b1;
        end

        if (state[4]) // S4
        begin
            if (!in)
                next_state[0] = 1'b1;
            else
                next_state[5] = 1'b1;
        end

        if (state[5]) // S5
        begin
            if (!in)
                next_state[8] = 1'b1;
            else
                next_state[6] = 1'b1;
        end

        if (state[6]) // S6
        begin
            if (!in)
                next_state[9] = 1'b1;
            else
                next_state[7] = 1'b1;
        end

        if (state[7]) // S7
        begin
            if (!in)
                next_state[0] = 1'b1;
            else
                next_state[7] = 1'b1;
            out1 = 1'b0;
            out2 = 1'b1;
        end

        if (state[8]) // S8
        begin
            if (!in)
                next_state[0] = 1'b1;
            else
                next_state[1] = 1'b1;
            out1 = 1'b1;
            out2 = 1'b0;
        end

        if (state[9]) // S9
        begin
            if (!in)
                next_state[0] = 1'b1;
            else
                next_state[1] = 1'b1;
            out1 = 1'b1;
            out2 = 1'b1;
        end
    end

endmodule