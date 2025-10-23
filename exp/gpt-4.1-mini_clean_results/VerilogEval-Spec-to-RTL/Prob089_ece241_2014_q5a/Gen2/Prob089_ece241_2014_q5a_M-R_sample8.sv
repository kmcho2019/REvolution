module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // State encoding
    localparam STATE_BEFORE_FIRST_ONE = 1'b0;
    localparam STATE_AFTER_FIRST_ONE  = 1'b1;

    reg state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= STATE_BEFORE_FIRST_ONE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            STATE_BEFORE_FIRST_ONE:
                next_state = (x == 1'b1) ? STATE_AFTER_FIRST_ONE : STATE_BEFORE_FIRST_ONE;
            STATE_AFTER_FIRST_ONE:
                next_state = STATE_AFTER_FIRST_ONE;
            default:
                next_state = STATE_BEFORE_FIRST_ONE;
        endcase
    end

    // Output logic (Moore machine): depends only on current state and input x combinationally
    assign z = (state == STATE_BEFORE_FIRST_ONE) ? x : ~x;

endmodule