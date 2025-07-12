module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    // Initialize all next_state bits to 0
    always @(*) begin
        next_state = 10'b0;
        out1 = 1'b0;
        out2 = 1'b0;

        // Check each state and determine the next state
        if (state[0]) begin // S0
            if (!in)
                next_state[0] = 1'b1; // Stay in S0
            else
                next_state[1] = 1'b1; // Go to S1
        end else if (state[1]) begin // S1
            if (!in)
                next_state[0] = 1'b1; // Go to S0
            else
                next_state[2] = 1'b1; // Go to S2
        end else if (state[2]) begin // S2
            if (!in)
                next_state[0] = 1'b1; // Go to S0
            else
                next_state[3] = 1'b1; // Go to S3
        end else if (state[3]) begin // S3
            if (!in)
                next_state[0] = 1'b1; // Go to S0
            else
                next_state[4] = 1'b1; // Go to S4
        end else if (state[4]) begin // S4
            if (!in)
                next_state[0] = 1'b1; // Go to S0
            else
                next_state[5] = 1'b1; // Go to S5
        end else if (state[5]) begin // S5
            if (!in)
                next_state[8] = 1'b1; // Go to S8
            else
                next_state[6] = 1'b1; // Go to S6
        end else if (state[6]) begin // S6
            if (!in)
                next_state[9] = 1'b1; // Go to S9
            else
                next_state[7] = 1'b1; // Go to S7
        end else if (state[7]) begin // S7
            if (!in)
                next_state[0] = 1'b1; // Go to S0
            else
                next_state[7] = 1'b1; // Stay in S7
            out2 = 1'b1;
        end else if (state[8]) begin // S8
            if (!in)
                next_state[0] = 1'b1; // Go to S0
            else
                next_state[1] = 1'b1; // Go to S1
            out1 = 1'b1;
        end else if (state[9]) begin // S9
            if (!in)
                next_state[0] = 1'b1; // Go to S0
            else
                next_state[1] = 1'b1; // Go to S1
            out1 = 1'b1;
            out2 = 1'b1;
        end
    end

endmodule