module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding
    typedef enum logic [2:0] {
        S0 = 3'd0, // initial state, no match
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4, // matched '1001'
        S5 = 3'd5  // matched '10011' (final matched state - output MATCH=1)
    } state_t;

    state_t current_state, next_state;

    // Next state logic
    always @(*) begin
        case (current_state)
            S0: begin
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                if (IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S1; // if input=1 again, stay in S1 since sequence starts with 1
            end

            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else if (IN == 1'b1)
                    next_state = S1; // Restart matching since sequence begins with 1
                else
                    next_state = S0;
            end

            S3: begin
                if (IN == 1'b1)
                    next_state = S4;
                else if (IN == 1'b0)
                    next_state = S0; // no partial prefix matched, return to S0
                else
                    next_state = S0;
            end

            S4: begin
                if (IN == 1'b1)
                    next_state = S5; // full sequence matched
                else if (IN == 1'b0)
                    next_state = S2; // partial overlap, as 1 0 0 1 then 0 could start matching 10 again
                else
                    next_state = S0;
            end

            S5: begin
                // When matched, we output MATCH=1 and then shift to proper next state
                // Because sequence is 10011, after match we can have overlap at S1 if input=1
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end

            default: next_state = S0;
        endcase
    end

    // State register and MATCH output (Mealy output)
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= S0;
            MATCH <= 1'b0;
        end else begin
            current_state <= next_state;

            // MATCH is 1 only in S5 on the clock that state transitions to S5
            // Because Mealy output depends on current input and current state,
            // We can output MATCH = 1 when next_state == S5
            MATCH <= (next_state == S5) ? 1'b1 : 1'b0;
        end
    end

endmodule