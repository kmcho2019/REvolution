module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;
    localparam OFF = 1'b0, ON = 1'b1;

    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else if (state == OFF)
            state <= j ? ON : OFF;
        else
            state <= k ? OFF : ON;
    end

    assign out = state;

endmodule