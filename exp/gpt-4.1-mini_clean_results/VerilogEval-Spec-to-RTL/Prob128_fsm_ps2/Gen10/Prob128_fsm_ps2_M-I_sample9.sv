module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    // Binary-encoded states
    localparam WAIT_FOR_START = 2'b00;
    localparam BYTE2          = 2'b01;
    localparam BYTE3          = 2'b10;

    reg [1:0] state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= WAIT_FOR_START;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            WAIT_FOR_START: next_state = in[3] ? BYTE2 : WAIT_FOR_START;
            BYTE2:          next_state = BYTE3;
            BYTE3:          next_state = WAIT_FOR_START;
            default:        next_state = WAIT_FOR_START;
        endcase
    end

    // done asserted combinationally: one cycle immediately after third byte received,
    // i.e., when current state is BYTE3 (means third byte just received this clock)
    assign done = (state == BYTE3);

endmodule