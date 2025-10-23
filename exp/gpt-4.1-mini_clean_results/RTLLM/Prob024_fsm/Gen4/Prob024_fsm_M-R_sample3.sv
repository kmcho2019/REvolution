module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding (one-hot style for clarity)
    typedef enum logic [2:0] {
        S0 = 3'd0,  // Initial state, no match progress
        S1 = 3'd1,  // Received '1'
        S2 = 3'd2,  // Received '10'
        S3 = 3'd3,  // Received '100'
        S4 = 3'd4,  // Received '1001'
        S5 = 3'd5   // Received '10011' (match state)
    } state_t;

    state_t state, next_state;

    // Combinational logic for next state and match output
    always @(*) begin
        next_state = S0;
        MATCH = 1'b0;
        case (state)
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
                    next_state = S1; // stay if 1
            end
            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else
                    next_state = S1; // restart sequence on '1'
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
                    MATCH = 1'b1;  // Mealy output: match when last '1' received
                end
                else
                    next_state = S2; // partial overlap detected, go to S2
            end
            S5: begin
                MATCH = 1'b1; // Output remains 1 on S5 (since last input is '1')
                if (IN == 1'b0)
                    next_state = S2; // overlap: next candidate sequence start
                else
                    next_state = S1;
            end
            default: begin
                next_state = S0;
                MATCH = 1'b0;
            end
        endcase
    end

    // State register with synchronous reset, MATCH also registered
    always @(posedge CLK) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end
        else begin
            state <= next_state;
            MATCH <= MATCH;
        end
    end

endmodule