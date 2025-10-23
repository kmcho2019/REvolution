module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // State encoding
    parameter OFF = 1'b0;
    parameter ON  = 1'b1;

    reg state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // State update (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Moore output depends only on state
    always @(posedge clk) begin
        out <= (state == ON) ? 1'b1 : 1'b0;
    end

endmodule