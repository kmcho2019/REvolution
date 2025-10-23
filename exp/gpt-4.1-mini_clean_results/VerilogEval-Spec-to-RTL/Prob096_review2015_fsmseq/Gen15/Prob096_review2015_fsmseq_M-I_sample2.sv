module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // One-hot state encoding: 5 states for sequence detection
    // S0 = no match, S1 = matched '1', S2 = matched "11", S3 = matched "110", S4 = detected "1101"
    reg S0, S1, S2, S3, S4;
    reg S0_next, S1_next, S2_next, S3_next, S4_next;

    // Synchronous active-high reset and state register update
    always @(posedge clk) begin
        if (reset) begin
            S0 <= 1'b1;
            S1 <= 1'b0;
            S2 <= 1'b0;
            S3 <= 1'b0;
            S4 <= 1'b0;
        end else begin
            S0 <= S0_next;
            S1 <= S1_next;
            S2 <= S2_next;
            S3 <= S3_next;
            S4 <= S4_next;
        end
    end

    // Next state logic for one-hot FSM
    always @(*) begin
        // Default next state assignments
        S0_next = 1'b0;
        S1_next = 1'b0;
        S2_next = 1'b0;
        S3_next = 1'b0;
        S4_next = 1'b0;

        // Once detected, remain latched in S4 forever
        if (S4) begin
            S4_next = 1'b1;
        end else begin
            // State transitions based on input data
            // From S0 (no match)
            if (S0) begin
                if (data)
                    S1_next = 1'b1; // matched first '1'
                else
                    S0_next = 1'b1; // stay in no match
            end
            // From S1 (matched '1')
            else if (S1) begin
                if (data)
                    S2_next = 1'b1; // matched "11"
                else
                    S0_next = 1'b1; // no match
            end
            // From S2 (matched "11")
            else if (S2) begin
                if (~data)
                    S3_next = 1'b1; // matched "110"
                else
                    S2_next = 1'b1; // remain in "11"
            end
            // From S3 (matched "110")
            else if (S3) begin
                if (data)
                    S4_next = 1'b1; // matched "1101" detected
                else
                    S0_next = 1'b1; // no match
            end
        end
    end

    // Output asserted once S4 is latched
    assign start_shifting = S4;

endmodule