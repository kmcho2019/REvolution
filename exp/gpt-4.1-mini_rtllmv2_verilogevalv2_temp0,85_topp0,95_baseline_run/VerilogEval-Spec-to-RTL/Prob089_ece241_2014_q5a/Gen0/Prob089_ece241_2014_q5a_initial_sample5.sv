module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding
    typedef enum logic {
        BEFORE_ONE,
        AFTER_ONE
    } state_t;

    state_t state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= BEFORE_ONE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            BEFORE_ONE: next_state = (x == 1'b1) ? AFTER_ONE : BEFORE_ONE;
            AFTER_ONE:  next_state = AFTER_ONE;
            default:    next_state = BEFORE_ONE;
        endcase
    end

    // Output logic: Moore machine - output depends only on state and current input
    always @(*) begin
        case (state)
            BEFORE_ONE: z = x;           // Output same bit until first '1'
            AFTER_ONE:  z = ~x;          // After first '1', invert bits
            default:    z = 1'b0;
        endcase
    end

endmodule