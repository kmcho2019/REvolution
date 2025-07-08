module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding for sequence detection of "1101"
    typedef enum reg [2:0] {
        IDLE = 3'd0,    // no bits matched
        S1   = 3'd1,    // matched '1'
        S11  = 3'd2,    // matched '11'
        S110 = 3'd3,    // matched '110'
        FOUND= 3'd4     // sequence found
    } state_t;

    state_t current_state, next_state;

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (data)       // input '1'
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                if (data)       // input '1'
                    next_state = S11;
                else            // input '0'
                    next_state = IDLE;
            end

            S11: begin
                if (!data)      // input '0'
                    next_state = S110;
                else            // input '1'
                    next_state = S11;  // stay in S11 since '11' matched
            end

            S110: begin
                if (data)       // input '1'
                    next_state = FOUND;
                else            // input '0'
                    next_state = IDLE;
            end

            FOUND: begin
                // stay here until reset
                next_state = FOUND;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for state and output
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            current_state <= next_state;
            if (next_state == FOUND)
                start_shifting <= 1'b1;
        end
    end

endmodule