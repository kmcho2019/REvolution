module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to all zeros
    assign next_state = 10'b0000000000;

    // Determine next state
    always @(*)
    begin
        if (state[9]) // S9
        begin
            if (!in)
                next_state[0] = 1'b1; // S0
            else
                next_state[1] = 1'b1; // S1
        end
        else if (state[8]) // S8
        begin
            if (!in)
                next_state[0] = 1'b1; // S0
            else
                next_state[1] = 1'b1; // S1
        end
        else if (state[7]) // S7
        begin
            if (!in)
                next_state[0] = 1'b1; // S0
            else
                next_state[7] = 1'b1; // S7
        end
        else if (state[6]) // S6
        begin
            if (!in)
                next_state[9] = 1'b1; // S9
            else
                next_state[7] = 1'b1; // S7
        end
        else if (state[5]) // S5
        begin
            if (!in)
                next_state[8] = 1'b1; // S8
            else
                next_state[6] = 1'b1; // S6
        end
        else if (state[4]) // S4
        begin
            if (!in)
                next_state[0] = 1'b1; // S0
            else
                next_state[5] = 1'b1; // S5
        end
        else if (state[3]) // S3
        begin
            if (!in)
                next_state[0] = 1'b1; // S0
            else
                next_state[4] = 1'b1; // S4
        end
        else if (state[2]) // S2
        begin
            if (!in)
                next_state[0] = 1'b1; // S0
            else
                next_state[3] = 1'b1; // S3
        end
        else if (state[1]) // S1
        begin
            if (!in)
                next_state[0] = 1'b1; // S0
            else
                next_state[2] = 1'b1; // S2
        end
        else if (state[0]) // S0
        begin
            if (!in)
                next_state[0] = 1'b1; // S0
            else
                next_state[1] = 1'b1; // S1
        end
    end

    // Determine outputs
    assign out1 = state[7] || state[9] || state[8];
    assign out2 = state[7] || state[9];

endmodule