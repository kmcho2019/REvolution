module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot state encoding for 6 states (6 bits)
    localparam [5:0]
        S0 = 6'b000001, // Initial state, waiting for first '1'
        S1 = 6'b000010, // After receiving '1'
        S2 = 6'b000100, // After "10"
        S3 = 6'b001000, // After "100"
        S4 = 6'b010000, // After "1001"
        S5 = 6'b100000; // After "10011" (final matched state)

    reg [5:0] state, next_state;

    // Next-state combinational logic for one-hot FSM
    always @(*) begin
        // Default next state is S0 (idle)
        next_state = S0;
        case (1'b1) // one-hot encoding check
            state[0]: // S0
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;

            state[1]: // S1 (matched '1')
                if (IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S1; // stay if '1' again

            state[2]: // S2 (matched "10")
                if (IN == 1'b0)
                    next_state = S3;
                else
                    next_state = S1; // restart from first '1' if '1'

            state[3]: // S3 (matched "100")
                if (IN == 1'b1)
                    next_state = S4;
                else
                    next_state = S0; // no partial match continue, reset

            state[4]: // S4 (matched "1001")
                if (IN == 1'b1)
                    next_state = S5;
                else
                    next_state = S2; // rollback to S2 for overlap if '0'

            state[5]: // S5 (matched "10011")
                if (IN == 1'b0)
                    next_state = S2; // continue overlap detection for next sequences
                else
                    next_state = S1; // possible start of new sequence
            default:
                next_state = S0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // MATCH asserted combinationally as Mealy output:
    // MATCH = 1 when FSM is at S4 and input is 1, i.e. when sequence "10011" completes.
    // In this design, MATCH is asserted exactly when going into S5 state.
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule