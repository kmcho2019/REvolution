module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        WAIT_FOR_START = 2'b00,
        BEFORE_FIRST_ONE = 2'b01,
        AFTER_FIRST_ONE = 2'b10
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            WAIT_FOR_START: begin
                if (~areset)
                    next_state = BEFORE_FIRST_ONE;
                else
                    next_state = WAIT_FOR_START;
            end
            BEFORE_FIRST_ONE: begin
                if (x == 1'b1)
                    next_state = AFTER_FIRST_ONE;
                else
                    next_state = BEFORE_FIRST_ONE;
            end
            AFTER_FIRST_ONE: begin
                next_state = AFTER_FIRST_ONE;
            end
            default: next_state = WAIT_FOR_START;
        endcase
    end

    // State update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WAIT_FOR_START;
        else
            state <= next_state;
    end

    // Output logic (Moore output: depends only on state and input)
    always @(*) begin
        case (state)
            WAIT_FOR_START: z = 1'b0;
            BEFORE_FIRST_ONE: z = x;
            AFTER_FIRST_ONE: z = ~x;
            default: z = 1'b0;
        endcase
    end

endmodule