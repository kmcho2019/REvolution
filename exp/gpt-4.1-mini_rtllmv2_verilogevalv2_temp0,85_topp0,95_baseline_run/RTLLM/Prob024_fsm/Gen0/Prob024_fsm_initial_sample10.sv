module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    // State encoding
    typedef enum reg [2:0] {
        S0 = 3'd0,  // no match yet
        S1 = 3'd1,  // matched '1'
        S2 = 3'd2,  // matched '10'
        S3 = 3'd3,  // matched '100'
        S4 = 3'd4,  // matched '1001'
        S5 = 3'd5   // matched '10011' - terminal state, output MATCH=1
    } state_t;

    state_t current_state, next_state;

    // Next state logic and output (Mealy output)
    always @(*) begin
        MATCH = 1'b0;
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
                    next_state = S1;  // if IN=1 again, stay in S1 (for overlapping)
            end
            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else
                    next_state = S1;  // if IN=1, restart matching from S1
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
                    MATCH = 1'b1;  // output MATCH when sequence detected
                end else if (IN == 1'b0)
                    next_state = S2; // partial overlap because last two bits are "00" in pattern
                else
                    next_state = S0;
            end
            S5: begin
                // After match, check for next possible sequence start
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
                MATCH = 1'b0; // MATCH asserted only on the cycle when sequence completes
            end
            default: begin
                next_state = S0;
                MATCH = 1'b0;
            end
        endcase
    end

    // State register with synchronous reset
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= S0;
            MATCH <= 1'b0;
        end else begin
            current_state <= next_state;
            // MATCH is combinational output in next_state logic; update here to keep stable
            if (current_state != S4)
                MATCH <= 1'b0;
            else if (IN == 1'b1)
                MATCH <= 1'b1;
            else
                MATCH <= 1'b0;
        end
    end

endmodule