module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot state encoding for pattern "10011":
    // S0: no match (initial)
    // S1: matched '1'
    // S2: matched '10'
    // S3: matched '100'
    // S4: matched '1001'
    reg S0, S1, S2, S3, S4;
    reg nS0, nS1, nS2, nS3, nS4;

    // Combinational next-state logic
    always @(*) begin
        // Default next states
        nS0 = 0; nS1 = 0; nS2 = 0; nS3 = 0; nS4 = 0;

        // From S0
        if (S0) begin
            if (IN)
                nS1 = 1;       // input '1' starts pattern
            else
                nS0 = 1;       // remain in S0 if IN=0
        end

        // From S1 (matched '1')
        if (S1) begin
            if (~IN)
                nS2 = 1;       // next bit '0' matches '10'
            else
                nS1 = 1;       // input '1' again, remain waiting for '0'
        end

        // From S2 (matched '10')
        if (S2) begin
            if (~IN)
                nS3 = 1;       // next bit '0' matches '100'
            else
                nS1 = 1;       // input '1' can start new pattern
        end

        // From S3 (matched '100')
        if (S3) begin
            if (IN)
                nS4 = 1;       // next bit '1' matches '1001'
            else
                nS0 = 1;       // mismatch, reset to S0
        end

        // From S4 (matched '1001')
        if (S4) begin
            if (IN)
                nS1 = 1;       // final input '1' completes pattern, start again
            else
                nS2 = 1;       // input '0' partial overlap ('10')
        end
    end

    // Sequential logic: state update with asynchronous reset
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            S0 <= 1;
            S1 <= 0;
            S2 <= 0;
            S3 <= 0;
            S4 <= 0;
        end else begin
            S0 <= nS0;
            S1 <= nS1;
            S2 <= nS2;
            S3 <= nS3;
            S4 <= nS4;
        end
    end

    // Mealy output: MATCH is 1 when in state S4 and IN=1 (final input bit)
    assign MATCH = S4 & IN;

endmodule