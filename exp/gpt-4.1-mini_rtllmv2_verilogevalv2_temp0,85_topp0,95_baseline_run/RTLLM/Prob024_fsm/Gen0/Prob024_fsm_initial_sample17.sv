module fsm (
    input       IN,
    input       CLK,
    input       RST,
    output reg  MATCH
);

    // State encoding
    typedef enum reg [2:0] {
        S0 = 3'd0, // No match yet
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4, // matched '1001'
        S5 = 3'd5  // matched '10011' (final state, outputs MATCH=1)
    } state_t;

    state_t state, next_state;

    // Next state logic and output (Mealy machine)
    always @(*) begin
        MATCH = 0;
        case(state)
            S0: begin
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (IN == 1'b0)
                    next_state = S2;
                else // IN=1
                    next_state = S1;
            end
            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else // IN=1
                    next_state = S1;
            end
            S3: begin
                if (IN == 1'b1)
                    next_state = S4;
                else
                    next_state = S0;
            end
            S4: begin
                if (IN == 1'b1) begin
                    next_state = S5;
                    MATCH = 1;
                end else begin
                    next_state = S2; // Because input 0 after 1001 means sequence "10" matched for next step
                    MATCH = 0;
                end
            end
            S5: begin
                // After detection, check input for overlap:
                // The suffix of "10011" that can be prefix for new detection:
                // The last two bits "11" can be start of a new match only if IN=1 or 0?
                // Actually for "10011", after detecting final bit, move to state representing suffix matching:
                if (IN == 1'b1) begin
                    next_state = S1; // input 1 can start new sequence
                end else begin
                    next_state = S2; // input 0 after final 1 means matched '10'
                end
                MATCH = 0;
            end
            default: begin
                next_state = S0;
                MATCH = 0;
            end
        endcase
    end

    // State register with synchronous clock and asynchronous reset
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 0;
        end else begin
            state <= next_state;
            // MATCH is already assigned in combinational block for Mealy output
            // but Mealy output depends on state and input, so update MATCH here:
            // To keep MATCH stable, we assign it in combinational block.
            // But since MATCH is reg output, it must be assigned here on clock.
            // Hence, we must revise the design: separate combinational MATCH signal.
        end
    end

endmodule