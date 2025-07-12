module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding:
    // 0: no match yet
    // 1: matched '1'
    // 2: matched '10'
    // 3: matched '100'
    // 4: matched '1001'

    reg [2:0] state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            3'd0: next_state = (IN) ? 3'd1 : 3'd0;
            3'd1: next_state = (IN) ? 3'd1 : 3'd2;
            3'd2: next_state = (IN) ? 3'd1 : 3'd3;
            3'd3: next_state = (IN) ? 3'd4 : 3'd0;
            3'd4: next_state = (IN) ? 3'd1 : 3'd2;
            default: next_state = 3'd0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // Output MATCH: asserted when state is 4 and IN=1 (final bit matched)
    assign MATCH = (state == 3'd4) && IN;

endmodule