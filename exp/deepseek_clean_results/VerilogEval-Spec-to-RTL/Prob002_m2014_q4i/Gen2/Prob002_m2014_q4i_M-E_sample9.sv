module TopModule (
    output reg out
);

    // Define states
    localparam STATE_ZERO = 1'b0;

    // State register
    reg state;

    initial begin
        state = STATE_ZERO;
        out = 1'b0;
    end

    // State machine logic
    always @(*) begin
        case (state)
            STATE_ZERO: out = 1'b0;
            default: out = 1'b0;
        endcase
    end

    // Next state logic (always stays in STATE_ZERO)
    always @(*) begin
        state = STATE_ZERO;
    end

endmodule