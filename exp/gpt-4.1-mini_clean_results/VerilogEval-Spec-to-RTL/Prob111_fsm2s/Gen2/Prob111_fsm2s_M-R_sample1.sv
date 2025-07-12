module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    parameter OFF = 1'b0;
    parameter ON  = 1'b1;

    reg state;
    wire next_state;

    // Combinational next state logic using assign
    assign next_state = (state == OFF) ? (j ? ON : OFF) :
                        (state == ON)  ? (k ? OFF : ON) : OFF;

    // State and output update in one always block (synchronous reset)
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            state <= next_state;
            out <= (next_state == ON) ? 1'b1 : 1'b0;
        end
    end

endmodule