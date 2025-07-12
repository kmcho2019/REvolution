module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    // State encoding: 
    // 0 - initial state, waiting for first '1'
    // 1 - matched '1'
    // 2 - matched '10'
    // 3 - matched '100'
    // 4 - matched '1001'
    typedef enum reg [2:0] {
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100
    } state_t;

    state_t current_state, next_state;

    // Next state logic and output (Mealy FSM)
    always @(*) begin
        // Default values
        next_state = current_state;
        MATCH = 1'b0;

        case (current_state)
            S0: begin
                if (IN)
                    next_state = S1;
                else
                    next_state = S0;
                // No match in initial states
            end
            S1: begin
                if (~IN)
                    next_state = S2;
                else
                    // Still see '1' => remain in S1 (start over)
                    next_state = S1;
            end
            S2: begin
                if (~IN)
                    next_state = S3;
                else
                    // Input is '1' breaks expected '0' here, but sequence start possible
                    next_state = S1;
            end
            S3: begin
                if (IN) 
                    next_state = S4;
                else
                    // If '0', restart looking for start '1'
                    next_state = S0;
            end
            S4: begin
                if (IN) begin
                    // Matched full sequence: 1 0 0 1 1
                    MATCH = 1'b1;
                    // After match, check for overlaps: last '1' could be start of next sequence
                    next_state = S1;
                end else begin
                    // If 0 at this point, restart from S2 (sequence "10" matched)
                    // Because '0' after '1001' matches the second char in "10011"
                    next_state = S2;
                end
            end
            default: begin
                next_state = S0;
                MATCH = 1'b0;
            end
        endcase
    end

    // State register update
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= S0;
            MATCH <= 1'b0;
        end else begin
            current_state <= next_state;
            // MATCH assigned combinationally above; Mealy output registers on clock
            // So we register MATCH here for output stability
        end
    end

endmodule