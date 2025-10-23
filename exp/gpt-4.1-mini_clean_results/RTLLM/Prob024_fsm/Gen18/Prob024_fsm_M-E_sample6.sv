module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // Define binary encoded states
    localparam [2:0]
        S0 = 3'd0,  // No bits matched
        S1 = 3'd1,  // matched '1'
        S2 = 3'd2,  // matched '10'
        S3 = 3'd3,  // matched '100'
        S4 = 3'd4;  // matched '1001'

    reg [2:0] state, next_state;

    // Sequential state update
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;

            // Mealy output: MATCH is asserted only if current transition completes "10011"
            // This happens when previous state = S4 and input IN=1
            if (state == S4 && IN == 1'b1)
                MATCH <= 1'b1;
            else
                MATCH <= 1'b0;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            S0: begin
                // Waiting for first '1' to start pattern
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                // Matched '1', next bit should be '0'
                if (IN == 1'b0)
                    next_state = S2;
                else
                    // If IN==1, stay in S1 since new sequence can start here
                    next_state = S1;
            end

            S2: begin
                // Matched '10', next bit should be '0'
                if (IN == 1'b0)
                    next_state = S3;
                else
                    // Mismatch: but IN==1 might start new pattern
                    next_state = S1;
            end

            S3: begin
                // Matched '100', next bit should be '1'
                if (IN == 1'b1)
                    next_state = S4;
                else
                    // Mismatch, reset to S0
                    next_state = S0;
            end

            S4: begin
                // Matched '1001', next bit should be '1' to complete sequence "10011"
                // If IN==1, MATCH will be asserted
                if (IN == 1'b1)
                    // After matching full sequence, pattern can restart if overlapping
                    next_state = S1;
                else if (IN == 1'b0)
                    // Partial suffix "10" matches, go to S2
                    next_state = S2;
                else
                    next_state = S0;
            end

            default: next_state = S0;
        endcase
    end

endmodule