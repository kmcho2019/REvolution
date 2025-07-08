module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    // State encoding
    typedef enum logic {
        OFF = 1'b0,
        ON  = 1'b1
    } state_t;

    state_t state, next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            OFF: next_state = (j) ? ON : OFF;
            ON:  next_state = (k) ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Output logic (Moore output depends only on current state)
    always @(*) begin
        case (state)
            OFF: out = 1'b0;
            ON:  out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule