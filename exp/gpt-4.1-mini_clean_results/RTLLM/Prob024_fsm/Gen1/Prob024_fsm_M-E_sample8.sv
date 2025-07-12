module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // States encoding:
    // Represent states as integers indicating how many bits matched in "10011"
    // S0 = 0 bits matched (start)
    // S1 = matched '1'
    // S2 = matched '10'
    // S3 = matched '100'
    // S4 = matched '1001'
    parameter S0 = 3'd0;
    parameter S1 = 3'd1;
    parameter S2 = 3'd2;
    parameter S3 = 3'd3;
    parameter S4 = 3'd4;

    reg [2:0] state, next_state;

    // Next state logic and output combinational block
    always @(*) begin
        // Default outputs
        next_state = S0;
        MATCH = 1'b0;

        case (state)
            S0: begin
                // Looking for first '1'
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                // Matched '1', next input '0' expected
                if (IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S1; // Stay in S1 if multiple '1's (still first bit matched)
            end

            S2: begin
                // Matched '10', expect another '0'
                if (IN == 1'b0)
                    next_state = S3;
                else if (IN == 1'b1)
                    next_state = S1; // Restart pattern from '1'
                else
                    next_state = S0; // Should not occur but safe default
            end

            S3: begin
                // Matched '100', expect '1'
                if (IN == 1'b1)
                    next_state = S4;
                else
                    next_state = S0; // Reset if mismatch
            end

            S4: begin
                // Matched '1001', expect final '1'
                if (IN == 1'b1) begin
                    next_state = S1; // After full match, restart from '1' to support overlapping
                    MATCH = 1'b1;    // Output MATCH when final bit matched
                end else if (IN == 1'b0) begin
                    next_state = S2; // Restart at matching '10' prefix (overlap restart)
                    MATCH = 1'b0;
                end else begin
                    next_state = S0;
                    MATCH = 1'b0;
                end
            end

            default: begin
                next_state = S0;
                MATCH = 1'b0;
            end
        endcase
    end

    // Sequential state update and synchronous reset
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH is combinational in next_state block to reflect Mealy output
            // Register MATCH to synchronize output timing with CLK
            MATCH <= MATCH;
        end
    end

endmodule