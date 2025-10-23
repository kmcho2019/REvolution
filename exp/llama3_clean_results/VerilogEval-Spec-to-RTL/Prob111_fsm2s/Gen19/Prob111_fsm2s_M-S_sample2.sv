module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // 0: OFF, 1: ON

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
    end else if (state == 0 && j) begin
        state <= 1;
    end else if (state == 1 && k) begin
        state <= 0;
    end
end

always @(posedge clk) begin
    out <= state;
end

endmodule