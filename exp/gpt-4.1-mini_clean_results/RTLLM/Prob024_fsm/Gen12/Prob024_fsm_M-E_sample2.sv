module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // One-hot encoding for states:
    // s0: no bits matched
    // s1: matched '1'
    // s2: matched '10'
    // s3: matched '100'
    // s4: matched '1001'
    // s5: matched '10011' (final state)

    typedef enum logic [5:0] {
        s0 = 6'b000001,
        s1 = 6'b000010,
        s2 = 6'b000100,
        s3 = 6'b001000,
        s4 = 6'b010000,
        s5 = 6'b100000
    } state_t;

    state_t state, next_state;

    // Next state logic combinational
    always @(*) begin
        // Default to s0 for safety
        next_state = s0;
        MATCH = 1'b0;

        case (state)
            s0: begin
                if (IN)
                    next_state = s1;
                else
                    next_state = s0;
            end
            s1: begin
                if (IN)
                    next_state = s1; // repeated '1's keep in s1
                else
                    next_state = s2; // got '10'
            end
            s2: begin
                if (IN)
                    next_state = s1; // '100' interrupted by '1' -> restart from s1
                else
                    next_state = s3; // got '100'
            end
            s3: begin
                if (IN)
                    next_state = s4; // got '1001'
                else
                    next_state = s0; // no prefix, back to s0
            end
            s4: begin
                if (IN) begin
                    next_state = s5; // got '10011' full pattern
                    MATCH = 1'b1;    // assert MATCH immediately (Mealy output)
                end else begin
                    next_state = s2; // '10010' partial prefix matches '10'
                end
            end
            s5: begin
                // After full match, shift detection for overlapping sequences:
                if (IN)
                    next_state = s1;
                else
                    next_state = s2;
                MATCH = 1'b0; // MATCH only asserted during s4+IN=1 cycle, so clear here
            end
            default: begin
                next_state = s0;
                MATCH = 1'b0;
            end
        endcase
    end

    // State register with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= s0;
        else
            state <= next_state;
    end

endmodule