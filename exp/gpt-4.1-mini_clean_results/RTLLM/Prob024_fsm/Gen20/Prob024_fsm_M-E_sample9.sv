module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding (binary encoded)
    typedef enum reg [2:0] {
        S0 = 3'd0, // no match
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4, // matched '1001'
        S5 = 3'd5  // matched '10011' (final state)
    } state_t;

    state_t state, next_state;

    // Next-state logic based on current state and input
    always @(*) begin
        case(state)
            S0: next_state = (IN) ? S1 : S0;
            S1: next_state = (IN) ? S1 : S2;     // If IN=1, stay in S1 (prefix '1'), else S2 ('10')
            S2: next_state = (IN) ? S1 : S3;     // If IN=1, restart from S1, else S3 ('100')
            S3: next_state = (IN) ? S4 : S0;     // If IN=1, go to S4 ('1001'), else reset S0
            S4: next_state = (IN) ? S5 : S2;     // If IN=1, full match '10011' (S5), else go to S2 (overlap '10')
            S5: next_state = (IN) ? S1 : S2;     // After full match, move to S1 or S2 depending on IN for overlap
            default: next_state = S0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge CLK) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH is 1 only when transitioning into S5 and IN=1 (final bit '1' received)
            MATCH <= (state == S4) && IN;
        end
    end

endmodule