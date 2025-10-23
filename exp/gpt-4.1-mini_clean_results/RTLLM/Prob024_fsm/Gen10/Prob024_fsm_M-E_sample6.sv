module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot state bits representing the number of bits matched so far
    reg S0, S1, S2, S3, S4;
    reg nS0, nS1, nS2, nS3, nS4;

    // Combinational next state logic
    always @(*) begin
        // Default next states = 0 (inactive)
        nS0 = 0;
        nS1 = 0;
        nS2 = 0;
        nS3 = 0;
        nS4 = 0;

        // Current states encoded as boolean signals
        // Next state logic based on IN and current states
        if (S0) begin
            // From no match: if IN=1 start sequence; else remain in S0
            if (IN) nS1 = 1;
            else    nS0 = 1;
        end
        else if (S1) begin
            // matched '1'
            if (IN) nS1 = 1;     // input 1: stay in S1 (possibly overlapping start)
            else    nS2 = 1;     // input 0: matched '10'
        end
        else if (S2) begin
            // matched '10'
            if (IN) nS1 = 1;     // input 1: restart sequence '1'
            else    nS3 = 1;     // input 0: matched '100'
        end
        else if (S3) begin
            // matched '100'
            if (IN) nS4 = 1;     // input 1: matched '1001'
            else    nS0 = 1;     // input 0: no partial match
        end
        else if (S4) begin
            // matched '1001'
            if (IN) nS1 = 1;     // input 1: full sequence '10011' matched at this clock, restart with '1'
            else    nS2 = 1;     // input 0: matched '10010' (partial overlap)
        end
        else begin
            // If somehow no state is active, reset to S0
            nS0 = 1;
        end
    end

    // Sequential state update
    always @(posedge CLK) begin
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

    // Mealy output: MATCH is 1 when last bit of sequence (IN=1) completes detection in S4 state
    assign MATCH = S4 & IN;

endmodule