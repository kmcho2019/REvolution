module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding
    localparam S0 = 3'd0; // no bits matched
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched '10'
    localparam S3 = 3'd3; // matched '100'
    localparam S4 = 3'd4; // matched '1001'
    localparam S5 = 3'd5; // matched '10011' (final state, used internally)

    reg [2:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            S0: next_state = IN ? S1 : S0;                // If IN=1, move to S1; else stay
            S1: next_state = IN ? S1 : S2;                // IN=1 stay in S1; IN=0 to S2
            S2: next_state = IN ? S1 : S3;                // IN=1 restart S1; IN=0 S3
            S3: next_state = IN ? S4 : S0;                // IN=1 S4; IN=0 reset S0
            S4: next_state = IN ? S5 : S2;                // IN=1 S5(final), IN=0 partial overlap S2
            S5: next_state = IN ? S1 : S2;                // After full match, restart detection
            default: next_state = S0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH asserted when current state is S4 and IN=1 (last input bit)
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule