module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding (3 bits for clarity)
    localparam [2:0]
        S0 = 3'd0,  // Initial state
        S1 = 3'd1,  // '1' detected
        S2 = 3'd2,  // '10' detected
        S3 = 3'd3,  // '100' detected
        S4 = 3'd4;  // '1001' detected

    reg [2:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            S0: next_state = IN ? S1 : S0;
            S1: next_state = IN ? S1 : S2;
            S2: next_state = IN ? S1 : S3;
            S3: next_state = IN ? S4 : S0;
            S4: next_state = IN ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    // Sequential state update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH asserted when in S4 and IN=1 (final '1' of sequence)
    assign MATCH = (state == S4) && IN;

endmodule