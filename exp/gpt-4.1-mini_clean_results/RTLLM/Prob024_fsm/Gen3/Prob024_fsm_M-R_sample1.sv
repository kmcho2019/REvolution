module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // One-hot state encoding for each matched prefix of "10011"
    // S0: no match
    // S1: matched '1'
    // S2: matched '10'
    // S3: matched '100'
    // S4: matched '1001'
    reg s0, s1, s2, s3, s4;
    wire next_s0, next_s1, next_s2, next_s3, next_s4;
    wire next_MATCH;

    // Next-state logic using one-hot encoding and combinational assigns
    // Transitions based on input IN and current state bits

    // S0 (no match)
    assign next_s1 = s0 & (IN == 1'b1) | s1 & (IN == 1'b1) | s4 & (IN == 1'b1);
    assign next_s0 = (s0 & (IN == 1'b0)) | (s1 & (IN == 1'b0)) | (s2 & (IN == 1'b0)) | (s3 & (IN == 1'b0) & ~IN) | (s4 & (IN == 1'b0) & 0); // s4 with IN=0 handled separately below

    // S1 (matched '1')
    assign next_s2 = s1 & (IN == 1'b0);
    // S1 stays if IN=1 (already included above)
    // S1 resets on others not covered (implicit from s0 assignment)

    // S2 (matched '10')
    assign next_s3 = s2 & (IN == 1'b0);
    assign next_s1 = next_s1 | (s2 & (IN == 1'b1)); // restart matching from '1' if IN=1 in s2

    // S3 (matched '100')
    assign next_s4 = s3 & (IN == 1'b1);
    assign next_s0 = next_s0 | (s3 & (IN == 1'b0)); // reset on mismatch

    // S4 (matched '1001')
    assign next_s1 = next_s1 | (s4 & (IN == 1'b1));  // after full match, restart at s1 if IN=1
    assign next_s2 = s4 & (IN == 1'b0);              // restart at s2 if IN=0

    // Next MATCH is 1 only when sequence completes on last input IN=1 in s4
    assign next_MATCH = s4 & (IN == 1'b1);

    // S0 override: if none of other next states active, remain in s0
    wire any_next = next_s1 | next_s2 | next_s3 | next_s4;
    assign next_s0 = next_s0 | (~any_next);

    // Sequential block: register state and MATCH on clock or reset
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            s0 <= 1'b1;
            s1 <= 1'b0;
            s2 <= 1'b0;
            s3 <= 1'b0;
            s4 <= 1'b0;
            MATCH <= 1'b0;
        end else begin
            s0 <= next_s0;
            s1 <= next_s1;
            s2 <= next_s2;
            s3 <= next_s3;
            s4 <= next_s4;
            MATCH <= next_MATCH;
        end
    end

endmodule