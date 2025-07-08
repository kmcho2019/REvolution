module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // Define states encoding how many bits matched in "10011"
    typedef enum logic [2:0] {
        S0 = 3'd0, // no match yet
        S1 = 3'd1, // matched "1"
        S2 = 3'd2, // matched "10"
        S3 = 3'd3, // matched "100"
        S4 = 3'd4, // matched "1001"
        S5 = 3'd5  // matched "10011" (output MATCH=1)
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
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
                else // IN==1
                    next_state = S1; // still matched first '1'
            end

            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else // IN==1
                    next_state = S1;
            end

            S3: begin
                if (IN == 1'b1)
                    next_state = S4;
                else // IN==0
                    next_state = S0;
            end

            S4: begin
                if (IN == 1'b1)
                    next_state = S5;
                else // IN==0
                    next_state = S2; // Because partial sequence "10" detected
            end

            S5: begin
                // After full sequence matched, decide next state for overlap
                // The last input was '1', check overlap with start of sequence
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S2;
            end

            default: next_state = S0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH = 1 only when we enter S5 (full match) - Mealy output
            MATCH <= (next_state == S5) ? 1'b1 : 1'b0;
        end
    end

endmodule