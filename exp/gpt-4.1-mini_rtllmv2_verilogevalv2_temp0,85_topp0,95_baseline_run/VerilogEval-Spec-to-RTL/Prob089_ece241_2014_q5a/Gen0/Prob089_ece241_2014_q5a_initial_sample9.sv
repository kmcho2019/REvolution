module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

// State encoding
localparam STATE_NO_ONE    = 1'b0;
localparam STATE_AFTER_ONE = 1'b1;

reg state, next_state;

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= STATE_NO_ONE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        STATE_NO_ONE: begin
            if (x == 1'b1)
                next_state = STATE_AFTER_ONE;
            else
                next_state = STATE_NO_ONE;
        end
        STATE_AFTER_ONE: begin
            next_state = STATE_AFTER_ONE;
        end
        default: next_state = STATE_NO_ONE;
    endcase
end

// Output logic (Moore: output depends only on current state and input)
always @(*) begin
    case (state)
        STATE_NO_ONE: z = x;       // before first '1', output input bit as is
        STATE_AFTER_ONE: z = ~x;   // after first '1', output inverted bits
        default: z = x;
    endcase
end

endmodule