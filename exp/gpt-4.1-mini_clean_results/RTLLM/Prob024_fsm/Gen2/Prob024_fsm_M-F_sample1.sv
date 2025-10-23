module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding representing how many bits matched in "10011"
    parameter S0 = 3'd0; // 0 bits matched
    parameter S1 = 3'd1; // matched '1'
    parameter S2 = 3'd2; // matched '10'
    parameter S3 = 3'd3; // matched '100'
    parameter S4 = 3'd4; // matched '1001'

    reg [2:0] state, next_state;
    reg       next_MATCH;

    // Combinational block: determine next_state and next_MATCH based on current state and input
    always @(*) begin
        // Defaults
        next_state = S0;
        next_MATCH = 1'b0;

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
                    next_state = S1; // stay in S1 for consecutive '1's (prefix)
            end

            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else if (IN == 1'b1)
                    next_state = S1; // restart pattern from '1'
                else
                    next_state = S0; // fallback
            end

            S3: begin
                if (IN == 1'b1)
                    next_state = S4;
                else
                    next_state = S0; // mismatch, reset
            end

            S4: begin
                if (IN == 1'b1) begin
                    next_state = S1;    // after full match, restart for overlap
                    next_MATCH = 1'b1;  // assert MATCH on last input of sequence
                end else if (IN == 1'b0) begin
                    next_state = S2;    // restart matching from '10' prefix
                    next_MATCH = 1'b0;
                end else begin
                    next_state = S0;
                    next_MATCH = 1'b0;
                end
            end

            default: begin
                next_state = S0;
                next_MATCH = 1'b0;
            end
        endcase
    end

    // Sequential block: update state and register MATCH on clock or reset
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            MATCH <= next_MATCH;
        end
    end

endmodule