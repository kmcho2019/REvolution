module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    // State encoding
    typedef enum reg [2:0] {
        S0 = 3'd0, // initial state, no match yet
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4, // matched '1001'
        S5 = 3'd5  // matched '10011' (final)
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
                else
                    next_state = S1; // input=1 again, stay in S1 (sequence start)
            end
            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else if (IN == 1'b1)
                    next_state = S1; // restart sequence from 1
                else
                    next_state = S0;
            end
            S3: begin
                if (IN == 1'b1)
                    next_state = S4;
                else
                    next_state = S0;
            end
            S4: begin
                if (IN == 1'b1)
                    next_state = S5; // final match state
                else if (IN == 1'b0)
                    next_state = S2; // partial overlap: after 1001 + 0, we have matched '10' again
                else
                    next_state = S0;
            end
            S5: begin
                // After match, check for overlap:
                // The last two bits are "11", so if next IN=0, we can go to S2 (matched '10')
                // If next IN=1, stay in S1 (start new sequence)
                if (IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S1;
            end
            default: next_state = S0;
        endcase
    end

    // State register and output logic
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH is 1 only when next_state is S5 and IN=1 (final bit of sequence)
            // Since this is Mealy, output depends on current input and state
            MATCH <= (next_state == S5) ? 1'b1 : 1'b0;
        end
    end

endmodule