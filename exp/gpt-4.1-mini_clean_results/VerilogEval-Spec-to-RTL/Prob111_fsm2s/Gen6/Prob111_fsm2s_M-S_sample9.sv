module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    typedef enum logic {OFF, ON} state_t;
    state_t state, next_state;

    always @(*) begin
        case(state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase;
    end

    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    always @(posedge clk) begin
        out <= (state == ON);
    end

endmodule