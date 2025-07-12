module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    typedef enum logic [0:0] {OFF = 1'b0, ON = 1'b1} state_t;
    state_t state, next_state;

    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else begin
            case (state)
                OFF: next_state = (j) ? ON : OFF;
                ON:  next_state = (k) ? OFF : ON;
                default: next_state = OFF;
            endcase
            state <= next_state;
        end
    end

    always @(*) begin
        out = (state == ON) ? 1'b1 : 1'b0;
    end

endmodule