module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam STATE_BEFORE_FIRST_ONE = 1'b0;
    localparam STATE_AFTER_FIRST_ONE  = 1'b1;

    reg state, next_state;

    // Next state logic and output combinational block
    always @(*) begin
        case (state)
            STATE_BEFORE_FIRST_ONE: begin
                z = x;                    // Output input bit directly
                if (x == 1'b1)
                    next_state = STATE_AFTER_FIRST_ONE;
                else
                    next_state = STATE_BEFORE_FIRST_ONE;
            end
            STATE_AFTER_FIRST_ONE: begin
                z = ~x;                   // Output inverted input bit
                next_state = STATE_AFTER_FIRST_ONE;
            end
            default: begin
                z = 1'b0;
                next_state = STATE_BEFORE_FIRST_ONE;
            end
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= STATE_BEFORE_FIRST_ONE;
        else
            state <= next_state;
    end

endmodule