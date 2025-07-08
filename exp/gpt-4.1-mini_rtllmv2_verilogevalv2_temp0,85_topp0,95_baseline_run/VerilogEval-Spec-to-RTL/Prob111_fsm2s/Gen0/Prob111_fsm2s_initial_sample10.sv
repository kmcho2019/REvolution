module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    typedef enum logic {OFF=1'b0, ON=1'b1} state_t;
    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            OFF: next_state = (j) ? ON : OFF;
            ON:  next_state = (k) ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output logic (Moore)
    always @(*) begin
        case(state)
            OFF: out = 1'b0;
            ON:  out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule