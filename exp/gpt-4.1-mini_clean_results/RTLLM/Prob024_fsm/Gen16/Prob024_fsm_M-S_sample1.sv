module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // States encoding
    localparam S0 = 3'd0; // no match yet
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched '10'
    localparam S3 = 3'd3; // matched '100'
    localparam S4 = 3'd4; // matched '1001'
    localparam S5 = 3'd5; // matched full sequence '10011' (output state)

    reg [2:0] state, next_state;

    // Sequential state update
    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            S0: next_state = (IN) ? S1 : S0;
            S1: next_state = (IN) ? S1 : S2;
            S2: next_state = (IN) ? S1 : S3;
            S3: next_state = (IN) ? S4 : S0;
            S4: next_state = (IN) ? S5 : S2;
            S5: next_state = (IN) ? S1 : S2; // after full match, continue detecting overlapping patterns
            default: next_state = S0;
        endcase
    end

    // Mealy output: MATCH=1 when sequence "10011" completes
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule