module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // Define states using parameters (standard Verilog)
    parameter OFF = 1'b0;
    parameter ON  = 1'b1;

    reg state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            OFF: next_state = (j == 1'b1) ? ON : OFF;
            ON:  next_state = (k == 1'b1) ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // State register with synchronous reset
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