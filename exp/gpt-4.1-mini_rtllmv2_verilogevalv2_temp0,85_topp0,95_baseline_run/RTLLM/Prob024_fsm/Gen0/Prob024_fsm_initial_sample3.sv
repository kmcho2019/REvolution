module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    // State encoding for the FSM
    typedef enum logic [2:0] {
        S0 = 3'd0, // initial state, no bits matched
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4  // matched '1001'
    } state_t;

    state_t state, next_state;

    // Next state logic and output logic (Mealy)
    always @(*) begin
        MATCH = 1'b0;
        case (state)
            S0: begin
                if (IN)      next_state = S1;
                else         next_state = S0;
            end
            S1: begin
                if (!IN)     next_state = S2;
                else         next_state = S1; // input '1' again, stay in S1 (pattern start)
            end
            S2: begin
                if (!IN)     next_state = S3;
                else         next_state = S1; // got '1' restart pattern from S1
            end
            S3: begin
                if (IN) begin
                    next_state = S4;
                end else begin
                    next_state = S0;
                end
            end
            S4: begin
                if (IN) begin
                    // Sequence "10011" detected here
                    MATCH = 1'b1;
                    // After MATCH, since the last two bits are "11",
                    // the next input might start the sequence again at '1' -> S1
                    next_state = S1;
                end else begin
                    MATCH = 1'b0;
                    // If input is 0 after "1001 1 0", fallback state for loop detection
                    next_state = S2; // because after "10011" if input=0, the last two bits "10" may start next sequence
                end
            end
            default: begin
                next_state = S0;
                MATCH = 1'b0;
            end
        endcase
    end

    // State register update on clock and reset
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH is combinational from above always block, but since MATCH is reg and
            // assigned combinationally, keep this to hold MATCH stable.
            if (state != S4) MATCH <= 1'b0;
            else MATCH <= MATCH; // keep MATCH asserted at cycle of detection
        end
    end

endmodule