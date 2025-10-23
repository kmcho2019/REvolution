module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    parameter OFF = 1'b0;
    parameter ON  = 1'b1;

    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else if (state == OFF)
            state <= j ? ON : OFF;
        else // state == ON
            state <= k ? OFF : ON;
    end

    assign out = state;

endmodule