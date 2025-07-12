module TopModule(
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to zero
    assign next_state = 10'd0;

    // Initialize outputs to zero
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    // State machine transitions
    always @(*) begin
        if (state[0]) begin // S0
            if (!in) begin
                next_state[0] = 1'b1; // Stay in S0
            end else begin
                next_state[1] = 1'b1; // Go to S1
            end
        end

        if (state[1]) begin // S1
            if (!in) begin
                next_state[0] = 1'b1; // Go to S0
            end else begin
                next_state[2] = 1'b1; // Go to S2
            end
        end

        if (state[2]) begin // S2
            if (!in) begin
                next_state[0] = 1'b1; // Go to S0
            end else begin
                next_state[3] = 1'b1; // Go to S3
            end
        end

        if (state[3]) begin // S3
            if (!in) begin
                next_state[0] = 1'b1; // Go to S0
            end else begin
                next_state[4] = 1'b1; // Go to S4
            end
        end

        if (state[4]) begin // S4
            if (!in) begin
                next_state[0] = 1'b1; // Go to S0
            end else begin
                next_state[5] = 1'b1; // Go to S5
            end
        end

        if (state[5]) begin // S5
            if (!in) begin
                next_state[8] = 1'b1; // Go to S8
            end else begin
                next_state[6] = 1'b1; // Go to S6
            end
        end

        if (state[6]) begin // S6
            if (!in) begin
                next_state[9] = 1'b1; // Go to S9
            end else begin
                next_state[7] = 1'b1; // Go to S7
            end
        end

        if (state[7]) begin // S7
            if (!in) begin
                next_state[0] = 1'b1; // Go to S0
            end else begin
                next_state[7] = 1'b1; // Stay in S7
                out1 = 1'b1; // Set out1 to 1
                out2 = 1'b1; // Set out2 to 1
            end
        end

        if (state[8]) begin // S8
            if (!in) begin
                next_state[0] = 1'b1; // Go to S0
            end else begin
                next_state[1] = 1'b1; // Go to S1
            end
            out1 = 1'b1; // Set out1 to 1
        end

        if (state[9]) begin // S9
            if (!in) begin
                next_state[0] = 1'b1; // Go to S0
            end else begin
                next_state[1] = 1'b1; // Go to S1
            end
            out1 = 1'b1; // Set out1 to 1
            out2 = 1'b1; // Set out2 to 1
        end
    end

endmodule