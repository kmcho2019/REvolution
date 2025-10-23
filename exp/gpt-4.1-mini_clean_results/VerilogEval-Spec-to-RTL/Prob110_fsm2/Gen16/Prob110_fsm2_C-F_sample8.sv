module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

localparam OFF = 1'b0;
localparam ON  = 1'b1;

reg state, next_state;

// Next-state logic using concise conditional expression
always @(*) begin
    next_state = (state == OFF) ? (j ? ON : OFF) :
                 (k ? OFF : ON);
end

// State and registered Moore output update with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
        out   <= 1'b0;
    end else begin
        state <= next_state;
        out   <= (next_state == ON);
    end
end

endmodule