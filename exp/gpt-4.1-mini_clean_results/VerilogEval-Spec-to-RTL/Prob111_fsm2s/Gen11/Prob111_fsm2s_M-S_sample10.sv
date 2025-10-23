module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    localparam OFF = 1'b0, ON = 1'b1;
    reg state, next_state;

    always @(*) begin
        next_state = (state == OFF) ? (j ? ON : OFF) : (k ? OFF : ON);
    end

    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    always @(state) begin
        out = state;
    end

endmodule