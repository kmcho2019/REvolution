module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding
    localparam STATE_WAITING = 1'b0;
    localparam STATE_INVERT  = 1'b1;

    reg state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            STATE_WAITING:
                if (x == 1'b1)
                    next_state = STATE_INVERT;
                else
                    next_state = STATE_WAITING;
            STATE_INVERT:
                next_state = STATE_INVERT;
            default:
                next_state = STATE_WAITING;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= STATE_WAITING;
        else
            state <= next_state;
    end

    // Output logic (Moore output depends only on state)
    // z = x if in STATE_WAITING, else z = ~x
    always @(*) begin
        case (state)
            STATE_WAITING: z = x;
            STATE_INVERT:  z = ~x;
            default:       z = 1'b0;
        endcase
    end

endmodule