module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // One-hot state encoding for sequence "1 0 0 1 1"
    // States represent how many bits matched so far:
    // S0: no match yet (initial state)
    // S1: matched '1'
    // S2: matched "10"
    // S3: matched "100"
    // S4: matched "1001"
    // S5: matched "10011" (final state)
    reg [5:0] state, next_state;

    // State bit positions for convenience
    localparam S0 = 6'b000001;
    localparam S1 = 6'b000010;
    localparam S2 = 6'b000100;
    localparam S3 = 6'b001000;
    localparam S4 = 6'b010000;
    localparam S5 = 6'b100000;

    // Next state combinational logic function
    always @(*) begin
        // Default next state is S0 (no match)
        next_state = S0;

        case (1'b1) // one-hot decode style
            state[0]: // S0
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;

            state[1]: // S1 (matched '1')
                if (IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S1; // stay in S1 if input 1 to allow overlapping starts

            state[2]: // S2 (matched "10")
                if (IN == 1'b0)
                    next_state = S3;
                else
                    next_state = S1; // restart at S1 if IN=1

            state[3]: // S3 (matched "100")
                if (IN == 1'b1)
                    next_state = S4;
                else
                    next_state = S0;

            state[4]: // S4 (matched "1001")
                if (IN == 1'b1)
                    next_state = S5;
                else
                    next_state = S2;

            state[5]: // S5 (matched "10011" - final)
                if (IN == 1'b0)
                    next_state = S2; // loops to prefix "10"
                else
                    next_state = S1; // restart at S1

            default:
                next_state = S0;
        endcase
    end

    // State register and MATCH output logic
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;

            // MATCH asserted when at S4 and input IN=1, which moves FSM to S5
            // For Mealy output, MATCH is set synchronous with the clock edge
            // and indicates detection of "10011" at the current input
            if (state == S4 && IN == 1'b1)
                MATCH <= 1'b1;
            else
                MATCH <= 1'b0;
        end
    end

endmodule