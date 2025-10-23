module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // State encoding using localparam for better synthesis optimization
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            OFF: next_state = (j) ? ON : OFF;
            ON:  next_state = (k) ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // State register and output update on rising edge of clk with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            state <= next_state;
            out <= next_state;  // output is 0 for OFF, 1 for ON (Moore output)
        end
    end

endmodule