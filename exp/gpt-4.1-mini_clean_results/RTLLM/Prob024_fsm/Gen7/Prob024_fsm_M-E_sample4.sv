module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding (binary) - 3 bits needed for 6 states
    typedef enum logic [2:0] {
        S0 = 3'd0,  // no match yet
        S1 = 3'd1,  // matched '1'
        S2 = 3'd2,  // matched '10'
        S3 = 3'd3,  // matched '100'
        S4 = 3'd4,  // matched '1001'
        S5 = 3'd5   // matched '10011' (terminal match state, but we don't stay here)
    } state_t;

    state_t state, next_state;

    // Next state logic for Mealy FSM detecting "10011"
    always @(*) begin
        case (state)
            S0: begin
                // From no match, if input=1, move to S1 (matched first bit)
                // else stay in S0
                next_state = (IN == 1'b1) ? S1 : S0;
            end

            S1: begin
                // matched '1'
                // next bit 0 -> matched '10' (S2)
                // next bit 1 -> remain in S1 (new start of pattern)
                next_state = (IN == 1'b0) ? S2 : S1;
            end

            S2: begin
                // matched '10'
                // next bit 0 -> matched '100' (S3)
                // next bit 1 -> restart matching '1' (S1)
                next_state = (IN == 1'b0) ? S3 : S1;
            end

            S3: begin
                // matched '100'
                // next bit 1 -> matched '1001' (S4)
                // next bit 0 -> no match (S0)
                next_state = (IN == 1'b1) ? S4 : S0;
            end

            S4: begin
                // matched '1001'
                // next bit 1 -> matched '10011' (S5) -> match output here
                // next bit 0 -> possible overlapping restart from '10' (S2)
                next_state = (IN == 1'b1) ? S5 : S2;
            end

            S5: begin
                // matched '10011' (last bit)
                // After reporting MATCH, we must update state as per input to detect overlap:
                // If input=1: treat as start of new pattern -> S1
                // If input=0: treat as second bit of pattern -> S2
                next_state = (IN == 1'b1) ? S1 : S2;
            end

            default: next_state = S0;
        endcase
    end

    // State register with asynchronous active-high reset
    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output MATCH asserted when current state is S4 and input is 1,
    // or equivalently when next_state is S5 (matched full sequence)
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule