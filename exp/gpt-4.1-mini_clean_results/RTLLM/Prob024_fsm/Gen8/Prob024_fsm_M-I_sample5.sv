module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot state encoding:
    // s0: initial/no match (state bit 0)
    // s1: matched '1'          (state bit 1)
    // s2: matched '10'         (state bit 2)
    // s3: matched '100'        (state bit 3)
    // s4: matched '1001'       (state bit 4)

    reg [4:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        next_state = 5'b00000; // default no state active

        case (1'b1)
            // Current state is s0
            state[0]: begin
                if (IN)
                    next_state[1] = 1'b1; // from s0 to s1 on '1'
                else
                    next_state[0] = 1'b1; // stay in s0 on '0'
            end

            // Current state is s1 (matched '1')
            state[1]: begin
                if (IN == 1'b0)
                    next_state[2] = 1'b1; // s1->s2 on '0'
                else
                    next_state[1] = 1'b1; // stay in s1 on '1' (overlapping)
            end

            // Current state is s2 (matched '10')
            state[2]: begin
                if (IN == 1'b0)
                    next_state[3] = 1'b1; // s2->s3 on '0'
                else
                    next_state[1] = 1'b1; // s2->s1 on '1' (restart pattern)
            end

            // Current state is s3 (matched '100')
            state[3]: begin
                if (IN == 1'b1)
                    next_state[4] = 1'b1; // s3->s4 on '1'
                else
                    next_state[0] = 1'b1; // s3->s0 on '0' breaks pattern
            end

            // Current state is s4 (matched '1001')
            state[4]: begin
                if (IN == 1'b1)
                    next_state[1] = 1'b1; // s4->s1 on '1' (pattern complete & overlap)
                else if (IN == 1'b0)
                    next_state[2] = 1'b1; // s4->s2 on '0'
                else
                    next_state[0] = 1'b1; // safety fallback
            end

            // Default fallback: reset to s0 if none active
            default: next_state[0] = 1'b1;
        endcase
    end

    // State register with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= 5'b00001; // reset to s0
        else
            state <= next_state;
    end

    // MATCH output (Mealy): asserted when currently in s4 and input IN=1
    assign MATCH = state[4] & IN;

endmodule