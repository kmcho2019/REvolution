module TopModule(
    input clk,
    input areset, // asynchronous active-high reset
    input x,
    output reg z
);

    // State encoding
    typedef enum logic {
        BEFORE_ONE = 1'b0,
        AFTER_ONE  = 1'b1
    } state_t;

    state_t state, next_state;

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= BEFORE_ONE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            BEFORE_ONE: begin
                if (x == 1'b1)
                    next_state = AFTER_ONE;
                else
                    next_state = BEFORE_ONE;
            end
            AFTER_ONE: begin
                next_state = AFTER_ONE;
            end
            default: next_state = BEFORE_ONE;
        endcase
    end

    // Output logic (Moore): output depends only on current state and input
    always @(*) begin
        case (state)
            BEFORE_ONE: z = x;        // copy input until first '1'
            AFTER_ONE:  z = ~x;       // invert after first '1'
            default:    z = 1'b0;
        endcase
    end

endmodule