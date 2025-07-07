module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    // State encoding
    typedef enum logic [2:0] {
        S0 = 3'd0, // initial state, no match yet
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4  // matched '1001'
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
                else // IN=1
                    next_state = S1; // stay in S1 because sequence starts with 1
            end
            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else // IN=1
                    next_state = S1; // restart from S1
            end
            S3: begin
                if (IN == 1'b1)
                    next_state = S4;
                else // IN=0
                    next_state = S0;
            end
            S4: begin
                if (IN == 1'b1)
                    next_state = S1; // because last input is 1, sequence can overlap
                else // IN=0
                    next_state = S2;
            end
            default: next_state = S0;
        endcase
    end

    // State and output update
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH is 1 only when current state is S4 and input IN=1 (last bit of sequence)
            // Because this is Mealy, MATCH depends on current input and state before transition
            // But here we update MATCH after state update, so MATCH=1 when next_state==S4 and IN=1
            // Actually, MATCH should be 1 when the sequence is detected at the current input
            // The sequence ends when we see IN=1 in state S4 (which means we just matched the last bit)
            // So MATCH = 1 when next_state == S4 and IN == 1
            // But next_state is computed combinationally, so we can use next_state and IN to set MATCH
            MATCH <= (next_state == S4) && (IN == 1'b1);
        end
    end

endmodule