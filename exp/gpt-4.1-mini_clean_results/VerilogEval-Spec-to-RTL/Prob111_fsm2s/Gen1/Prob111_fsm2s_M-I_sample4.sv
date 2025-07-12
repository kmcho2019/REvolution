module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // Define states using parameters for compatibility with Verilog tools
    parameter OFF = 1'b0, ON = 1'b1;

    reg state, next_state;

    // State transition (sequential logic)
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Output logic (Moore machine, output depends only on state)
    always @(*) begin
        case (state)
            OFF: out = 1'b0;
            ON:  out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule