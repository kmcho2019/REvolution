module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding
    typedef enum logic [2:0] {
        S0 = 3'd0, // start state, no match so far
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4, // matched '1001'
        S5 = 3'd5  // matched '10011' (final state, triggers MATCH)
    } state_t;

    state_t state, next_state;

    // Next state logic (Mealy FSM)
    always @(*) begin
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
                    next_state = S1; // stay here if continuous 1s (pattern needs a zero next)
            end
            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else if (IN == 1'b1)
                    next_state = S1; // partial restart from 1
                else
                    next_state = S0;
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
                    MATCH = 1'b1; // Sequence matched at this input cycle
                end else if (IN == 1'b0)
                    next_state = S2; // Overlap detection restart from '10'
                else
                    next_state = S0;
            end
            S5: begin
                // After match output, decide next state for overlap detection
                if (IN == 1'b1)
                    next_state = S1;
                else if (IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S0;
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

    // State update and synchronous reset
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH is combinational assigned in next_state logic, latch it here for output timing
            // The combinational MATCH in next_state logic is the output at current input
            // We keep MATCH from next_state block synchronized by assigning it here again
            // It is updated combinationally for Mealy behavior on input.
            // Actually, to keep MATCH synchronous with CLK, assign MATCH here as next_state-driven.
            MATCH <= MATCH; // Keep the combinational assignment, will update next cycle
        end
    end

endmodule