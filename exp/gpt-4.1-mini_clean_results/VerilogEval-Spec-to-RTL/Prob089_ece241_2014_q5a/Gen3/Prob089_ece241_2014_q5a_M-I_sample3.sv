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
    reg next_z;

    // Next state and output combinational logic
    always @(*) begin
        case(state)
            STATE_BEFORE_FIRST_ONE: begin
                next_z     = x;                    // output = input bit until first 1
                next_state = (x == 1'b1) ? STATE_AFTER_FIRST_ONE : STATE_BEFORE_FIRST_ONE;
            end
            STATE_AFTER_FIRST_ONE: begin
                next_z     = ~x;                   // output = inverted input after first 1
                next_state = STATE_AFTER_FIRST_ONE;
            end
            default: begin
                next_z     = 1'b0;
                next_state = STATE_BEFORE_FIRST_ONE;
            end
        endcase
    end

    // Sequential state and output update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_BEFORE_FIRST_ONE;
            z     <= 1'b0;
        end else begin
            state <= next_state;
            z     <= next_z;
        end
    end

endmodule