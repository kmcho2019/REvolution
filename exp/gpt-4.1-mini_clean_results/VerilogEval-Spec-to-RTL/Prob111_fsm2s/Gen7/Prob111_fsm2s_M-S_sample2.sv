module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    localparam OFF = 1'b0, ON = 1'b1;
    reg state, next_state;

    always @(*) begin
        if (state == OFF)
            next_state = (j) ? ON : OFF;
        else // state == ON
            next_state = (k) ? OFF : ON;
    end

    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    always @(*) begin
        out = (state == ON) ? 1'b1 : 1'b0;
    end

endmodule