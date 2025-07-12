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
    case (state)
        OFF: next_state = (j == 1'b1) ? ON : OFF;
        ON:  next_state = (k == 1'b1) ? OFF : ON;
        default: next_state = OFF;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= OFF;
        out <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            OFF: out <= 1'b0;
            ON:  out <= 1'b1;
            default: out <= 1'b0;
        endcase
    end
end

endmodule