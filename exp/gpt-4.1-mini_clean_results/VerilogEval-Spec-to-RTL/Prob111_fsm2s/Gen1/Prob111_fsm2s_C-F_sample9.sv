module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // State encoding with localparams for minimal overhead
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // State and output register update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out <= 1'b0;         // output registered to reduce glitches and power
        end else begin
            state <= next_state;
            out <= next_state;   // since output is Moore: out = 1 if ON, 0 if OFF
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

endmodule