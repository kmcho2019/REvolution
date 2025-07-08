module TopModule(
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam STATE_COPY   = 1'b0;
    localparam STATE_INVERT = 1'b1;

    reg state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= STATE_COPY;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            STATE_COPY: begin
                if (x == 1'b1)
                    next_state = STATE_INVERT;
                else
                    next_state = STATE_COPY;
            end
            STATE_INVERT: next_state = STATE_INVERT;
            default: next_state = STATE_COPY;
        endcase
    end

    // Output logic (Moore machine: output depends only on state and input)
    always @(*) begin
        case(state)
            STATE_COPY: z = x;
            STATE_INVERT: z = ~x;
            default: z = 1'b0;
        endcase
    end

endmodule