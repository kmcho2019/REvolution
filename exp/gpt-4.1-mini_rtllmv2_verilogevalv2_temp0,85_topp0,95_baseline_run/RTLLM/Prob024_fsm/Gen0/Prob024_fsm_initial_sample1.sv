module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    // State encoding
    typedef enum reg [2:0] {
        S0 = 3'd0, // initial state, no bits matched
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4, // matched '1001'
        S5 = 3'd5  // matched '10011' (final)
    } state_t;

    state_t current_state, next_state;

    // Next state logic combinational
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
                    next_state = S1;  // input 1 again, remain in S1 (match first bit again)
            end
            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else
                    next_state = S1;  // input 1 breaks "00", restart from S1
            end
            S3: begin
                if (IN == 1'b1)
                    next_state = S4;
                else
                    next_state = S0; // no partial match on 0, reset
            end
            S4: begin
                if (IN == 1'b1)
                    next_state = S5; // final match state
                else if (IN == 1'b0)
                    next_state = S2; // partial overlap: 1001 + 0 = matching "10" prefix
                else
                    next_state = S0;
            end
            S5: begin
                // After match, because of overlap, determine next state based on input
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S2;
            end
            default: next_state = S0;
        endcase
    end

    // State and output logic sequential
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= S0;
            MATCH <= 1'b0;
        end else begin
            current_state <= next_state;
            // MATCH is 1 only when next_state is the final match state S5
            MATCH <= (next_state == S5) ? 1'b1 : 1'b0;
        end
    end

endmodule