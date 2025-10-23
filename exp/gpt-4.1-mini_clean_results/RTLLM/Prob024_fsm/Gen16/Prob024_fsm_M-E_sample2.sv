module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding (3 bits):
    // S0 (3'd0): no bits matched
    // S1 (3'd1): matched '1'
    // S2 (3'd2): matched '10'
    // S3 (3'd3): matched '100'
    // S4 (3'd4): matched '1001'

    reg [2:0] state, next_state;

    // Sequential state update
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= 3'd0;  // Reset to S0
            MATCH <= 1'b0;
        end else begin
            state <= next_state;

            // Mealy output logic: MATCH = 1 if current input IN completes sequence "10011"
            // i.e. when in S4 and IN==1 at current clock cycle
            MATCH <= (state == 3'd4) && (IN == 1'b1);
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            3'd0: begin // No bits matched
                if (IN == 1'b1)
                    next_state = 3'd1;  // matched first '1'
                else
                    next_state = 3'd0;  // stay idle
            end
            3'd1: begin // matched '1'
                if (IN == 1'b0)
                    next_state = 3'd2;  // matched '10'
                else
                    next_state = 3'd1;  // still matched '1' (new sequence start)
            end
            3'd2: begin // matched '10'
                if (IN == 1'b0)
                    next_state = 3'd3;  // matched '100'
                else
                    next_state = 3'd1;  // restart from '1'
            end
            3'd3: begin // matched '100'
                if (IN == 1'b1)
                    next_state = 3'd4;  // matched '1001'
                else
                    next_state = 3'd0;  // reset to idle, mismatch
            end
            3'd4: begin // matched '1001'
                // If IN==1, sequence '10011' detected (output MATCH=1)
                // Also support overlapping detection:
                // For IN==1, restart from S1 (matched '1')
                // For IN==0, partial match '10' again (S2)
                if (IN == 1'b1)
                    next_state = 3'd1;
                else
                    next_state = 3'd2;
            end
            default: next_state = 3'd0; // Safety fallback
        endcase
    end

endmodule