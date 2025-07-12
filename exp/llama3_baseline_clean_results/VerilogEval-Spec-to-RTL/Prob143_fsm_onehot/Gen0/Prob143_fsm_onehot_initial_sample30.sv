module TopModule (
    input  logic in,
    input  logic [9:0] state,
    output logic [9:0] next_state,
    output logic out1,
    output logic out2
);

    always_comb begin
        next_state = 10'b0; // Initialize next_state to 0
        out1 = 1'b0; // Initialize out1 to 0
        out2 = 1'b0; // Initialize out2 to 0

        // S0
        if (state[0] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Stay in S0
            end else begin
                next_state[1] = 1'b1; // Go to S1
            end
        end

        // S1
        if (state[1] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Go to S0
            end else begin
                next_state[2] = 1'b1; // Go to S2
            end
        end

        // S2
        if (state[2] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Go to S0
            end else begin
                next_state[3] = 1'b1; // Go to S3
            end
        end

        // S3
        if (state[3] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Go to S0
            end else begin
                next_state[4] = 1'b1; // Go to S4
            end
        end

        // S4
        if (state[4] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Go to S0
            end else begin
                next_state[5] = 1'b1; // Go to S5
            end
        end

        // S5
        if (state[5] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[8] = 1'b1; // Go to S8
            end else begin
                next_state[6] = 1'b1; // Go to S6
            end
        end

        // S6
        if (state[6] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[9] = 1'b1; // Go to S9
            end else begin
                next_state[7] = 1'b1; // Go to S7
            end
        end

        // S7
        if (state[7] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Go to S0
            end else begin
                next_state[7] = 1'b1; // Stay in S7
            end
            out2 = 1'b1; // Set out2 to 1 in S7
        end

        // S8
        if (state[8] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Go to S0
            end else begin
                next_state[1] = 1'b1; // Go to S1
            end
            out1 = 1'b1; // Set out1 to 1 in S8
        end

        // S9
        if (state[9] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1; // Go to S0
            end else begin
                next_state[1] = 1'b1; // Go to S1
            end
            out1 = 1'b1; // Set out1 to 1 in S9
            out2 = 1'b1; // Set out2 to 1 in S9
        end
    end
endmodule