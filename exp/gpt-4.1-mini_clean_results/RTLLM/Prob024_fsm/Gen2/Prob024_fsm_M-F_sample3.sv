module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding: how many bits matched in "10011"
    parameter S0 = 3'd0; // no match yet
    parameter S1 = 3'd1; // matched '1'
    parameter S2 = 3'd2; // matched '10'
    parameter S3 = 3'd3; // matched '100'
    parameter S4 = 3'd4; // matched '1001'

    reg [2:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
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
                    next_state = S1; // stay if input is '1'
            end

            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else // IN == 1
                    next_state = S1;
            end

            S3: begin
                if (IN == 1'b1)
                    next_state = S4;
                else
                    next_state = S0;
            end

            S4: begin
                // After matching "1001", wait for last '1'
                if (IN == 1'b1)
                    next_state = S1; // restart from prefix '1' for overlapping
                else // IN == 0
                    next_state = S2; // restart from '10' prefix for overlapping
            end

            default: next_state = S0;
        endcase
    end

    // State register update (synchronous)
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH is generated combinationally, assign here for registration or leave as combinational below
            // To produce MATCH output at the same clock cycle as the last input '1',
            // assign MATCH combinationally below and register MATCH output here if required.
            // To keep Mealy behavior, MATCH is combinational, so just register the combinational value.
            // We'll implement MATCH logic combinationally in a separate always block.
        end
    end

    // Combinational logic for MATCH output (Mealy output)
    // MATCH = 1 when state = S4 and input IN=1 (final bit of sequence matched)
    always @(*) begin
        if (state == S4 && IN == 1'b1)
            MATCH = 1'b1;
        else
            MATCH = 1'b0;
    end

endmodule