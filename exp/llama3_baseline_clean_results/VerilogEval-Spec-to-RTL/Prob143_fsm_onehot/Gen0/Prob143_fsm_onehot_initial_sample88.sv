module TopModule(
    input  in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    always @(*) begin
        next_state = 10'b0; // Initialize next_state to zero
        out1 = 1'b0;
        out2 = 1'b0;

        // Check for S0
        if (state[0] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Stay in S0
            end else if (in == 1'b1) begin
                next_state[1] = 1'b1; // Go to S1
            end
        end

        // Check for S1
        if (state[1] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Go to S0
            end else if (in == 1'b1) begin
                next_state[2] = 1'b1; // Go to S2
            end
        end

        // Check for S2
        if (state[2] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Go to S0
            end else if (in == 1'b1) begin
                next_state[3] = 1'b1; // Go to S3
            end
        end

        // Check for S3
        if (state[3] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Go to S0
            end else if (in == 1'b1) begin
                next_state[4] = 1'b1; // Go to S4
            end
        end

        // Check for S4
        if (state[4] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Go to S0
            end else if (in == 1'b1) begin
                next_state[5] = 1'b1; // Go to S5
            end
        end

        // Check for S5
        if (state[5] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[8] = 1'b1; // Go to S8
            end else if (in == 1'b1) begin
                next_state[6] = 1'b1; // Go to S6
            end
        end

        // Check for S6
        if (state[6] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[9] = 1'b1; // Go to S9
            end else if (in == 1'b1) begin
                next_state[7] = 1'b1; // Go to S7
            end
        end

        // Check for S7
        if (state[7] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Go to S0
            end else if (in == 1'b1) begin
                next_state[7] = 1'b1; // Stay in S7
                out1 = 1'b0;
                out2 = 1'b1;
            end
        end

        // Check for S8
        if (state[8] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Go to S0
            end else if (in == 1'b1) begin
                next_state[1] = 1'b1; // Go to S1
            end
            out1 = 1'b1;
            out2 = 1'b0;
        end

        // Check for S9
        if (state[9] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Go to S0
            end else if (in == 1'b1) begin
                next_state[1] = 1'b1; // Go to S1
            end
            out1 = 1'b1;
            out2 = 1'b1;
        end
    end

endmodule