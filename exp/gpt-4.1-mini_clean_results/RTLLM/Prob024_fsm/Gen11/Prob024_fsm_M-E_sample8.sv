module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot encoded states for sequence detection "1 0 0 1 1"
    // S0: reset / no match
    // S1: matched '1'
    // S2: matched '10'
    // S3: matched '100'
    // S4: matched '1001'
    // S5: matched '10011' (final state)

    reg S0, S1, S2, S3, S4, S5;
    reg nS0, nS1, nS2, nS3, nS4, nS5;

    // Next state combinational logic
    always @(*) begin
        // Default next states are zero; only one should be active at a time
        nS0 = 0; nS1 = 0; nS2 = 0; nS3 = 0; nS4 = 0; nS5 = 0;

        // From S0 (no match)
        if (IN)
            nS1 = 1;       // Got '1', move to S1
        else
            nS0 = 1;       // Stay in S0 if IN=0

        // From S1 (matched '1')
        if (S1) begin
            if (IN == 1'b0)
                nS2 = 1;   // matched '10'
            else
                nS1 = 1;   // still matched '1' if IN=1 (repeated '1's)
        end

        // From S2 (matched '10')
        if (S2) begin
            if (IN == 1'b0)
                nS3 = 1;   // matched '100'
            else
                nS1 = 1;   // IN=1 might be start of new sequence '1'
        end

        // From S3 (matched '100')
        if (S3) begin
            if (IN == 1'b1)
                nS4 = 1;   // matched '1001'
            else
                nS0 = 1;   // mismatch reset
        end

        // From S4 (matched '1001')
        if (S4) begin
            if (IN == 1'b1)
                nS5 = 1;   // matched '10011' (final)
            else
                nS2 = 1;   // overlap: next possible matched prefix '10'
        end

        // From S5 (matched full sequence)
        if (S5) begin
            // After recognizing sequence, determine next state based on input for overlap
            if (IN == 1'b1)
                nS1 = 1;   // new sequence start
            else
                nS2 = 1;   // partial overlap with '10'
        end
    end

    // State registers with synchronous reset
    always @(posedge CLK) begin
        if (RST) begin
            S0 <= 1'b1;
            S1 <= 1'b0;
            S2 <= 1'b0;
            S3 <= 1'b0;
            S4 <= 1'b0;
            S5 <= 1'b0;
        end else begin
            S0 <= nS0;
            S1 <= nS1;
            S2 <= nS2;
            S3 <= nS3;
            S4 <= nS4;
            S5 <= nS5;
        end
    end

    // Mealy output: MATCH=1 only during transition into final state with IN=1
    // Since S5 is final state for matched sequence, assert MATCH when in S5
    // Here, MATCH is high whenever state S5 is active (indicating sequence matched on last IN)
    assign MATCH = S5;

endmodule