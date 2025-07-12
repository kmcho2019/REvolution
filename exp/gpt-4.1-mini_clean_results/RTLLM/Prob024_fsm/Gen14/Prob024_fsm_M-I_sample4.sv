module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding: number of matched bits in the sequence "10011"
    // States: 0 (no match) to 5 (full match)
    localparam S0 = 3'd0; // no bits matched
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched '10'
    localparam S3 = 3'd3; // matched '100'
    localparam S4 = 3'd4; // matched '1001'
    localparam S5 = 3'd5; // matched '10011' (transient)

    reg [2:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        case (state)
            S0: begin
                // From no match state:
                // If IN=1 start matching at S1, else stay in S0
                next_state = (IN == 1'b1) ? S1 : S0;
                MATCH = 1'b0;
            end

            S1: begin
                // Matched '1', next bit should be '0' -> S2
                // If IN=0 -> S2, else if IN=1 restart pattern (S1)
                next_state = (IN == 1'b0) ? S2 : S1;
                MATCH = 1'b0;
            end

            S2: begin
                // Matched '10', next bit should be '0' -> S3
                // If IN=0 -> S3, else if IN=1 restart pattern (S1)
                next_state = (IN == 1'b0) ? S3 : S1;
                MATCH = 1'b0;
            end

            S3: begin
                // Matched '100', next bit should be '1' -> S4
                // If IN=1 -> S4, else reset (S0)
                next_state = (IN == 1'b1) ? S4 : S0;
                MATCH = 1'b0;
            end

            S4: begin
                // Matched '1001', next bit '1' completes sequence -> MATCH=1
                if (IN == 1'b1) begin
                    // MATCH asserted here
                    MATCH = 1'b1;
                    // After full match, overlap detection:
                    // The last two bits '11' can be prefix for next '1' or '10'
                    // Since IN=1, restart pattern at S1
                    next_state = S1;
                end else begin
                    MATCH = 1'b0;
                    // If IN=0 after '1001', next state is S2 (matched '10')
                    next_state = S2;
                end
            end

            default: begin
                next_state = S0;
                MATCH = 1'b0;
            end
        endcase
    end

    // Sequential state update and MATCH reset on RST
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH is combinational, but registered here to meet spec of synchronous output
            // Actually MATCH is Mealy output and asserted combinationally above,
            // so we latch it here to avoid glitches. Alternatively, output can be assigned combinationally outside always block.
        end
    end

endmodule