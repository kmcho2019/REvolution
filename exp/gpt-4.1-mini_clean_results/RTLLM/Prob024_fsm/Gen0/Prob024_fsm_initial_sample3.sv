module fsm(
    input       IN,
    input       CLK,
    input       RST,
    output reg  MATCH
);

    // State encoding
    typedef enum logic [2:0] {
        S0 = 3'b000,  // no match yet
        S1 = 3'b001,  // matched '1'
        S2 = 3'b010,  // matched '10'
        S3 = 3'b011,  // matched '100'
        S4 = 3'b100,  // matched '1001'
        S5 = 3'b101   // matched '10011' (final match, output MATCH=1)
    } state_t;

    state_t current_state, next_state;

    // Next state logic
    always @(*) begin
        case(current_state)
            S0: begin
                if(IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if(IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S1;  // If input is 1, still in S1 (pattern start)
            end
            S2: begin
                if(IN == 1'b0)
                    next_state = S3;
                else if(IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S3: begin
                if(IN == 1'b1)
                    next_state = S4;
                else
                    next_state = S0;
            end
            S4: begin
                if(IN == 1'b1)
                    next_state = S5;
                else if(IN == 1'b0)
                    next_state = S2; // loop back for overlapping detection
                else
                    next_state = S0;
            end
            S5: begin
                // After match, check next input for overlapping:
                // The last two inputs were '11'. If next input is 0, go to S2 (matched '10' part),
                // if 1, remain in S1 (start of pattern)
                if(IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S2;
            end
            default: next_state = S0;
        endcase
    end

    // State and output update
    always @(posedge CLK or posedge RST) begin
        if(RST) begin
            current_state <= S0;
            MATCH <= 1'b0;
        end else begin
            current_state <= next_state;
            // MATCH is 1 only when the FSM enters S5 (final match state) at the current clock
            MATCH <= (next_state == S5) ? 1'b1 : 1'b0;
        end
    end

endmodule