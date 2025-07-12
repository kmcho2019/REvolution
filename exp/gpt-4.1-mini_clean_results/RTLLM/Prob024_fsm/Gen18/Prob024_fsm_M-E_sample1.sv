module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // States encoding (binary):
    // 0: S0 - no match yet
    // 1: S1 - matched '1'
    // 2: S2 - matched '10'
    // 3: S3 - matched '100'
    // 4: S4 - matched '1001'
    // 5: S5 - full match detected (transient, outputs MATCH)

    reg [2:0] state, next_state;

    // On reset or clock edge, update the state
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= 3'd0;  // Reset to S0
            MATCH <= 1'b0;
        end else begin
            state <= next_state;

            // Generate MATCH output: 
            // MATCH = 1 if current state is S4 and IN=1 (completes "10011" sequence)
            // This is a Mealy output, so we update MATCH combinationally with state change and input
            MATCH <= (state == 3'd4) && (IN == 1'b1);
        end
    end

    // Next state combinational logic with overlapping detection
    always @(*) begin
        case (state)
            3'd0: begin // S0: no bits matched
                if (IN == 1'b1)
                    next_state = 3'd1; // matched '1'
                else
                    next_state = 3'd0; // remain idle
            end

            3'd1: begin // S1: matched '1'
                if (IN == 1'b0)
                    next_state = 3'd2; // matched '10'
                else
                    next_state = 3'd1; // stay at '1' to support overlapping sequences
            end

            3'd2: begin // S2: matched '10'
                if (IN == 1'b0)
                    next_state = 3'd3; // matched '100'
                else
                    next_state = 3'd1; // mismatch but IN=1 can be start of new match
            end

            3'd3: begin // S3: matched '100'
                if (IN == 1'b1)
                    next_state = 3'd4; // matched '1001'
                else
                    next_state = 3'd0; // mismatch, reset
            end

            3'd4: begin // S4: matched '1001'
                // If IN==1, sequence complete "10011", MATCH will be 1 this cycle
                // Move to S1 for possible overlap start
                if (IN == 1'b1)
                    next_state = 3'd1;
                else
                    next_state = 3'd2; // IN=0 could be start of '10' for overlap
            end

            default: next_state = 3'd0; // default fallback
        endcase
    end

endmodule