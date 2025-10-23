module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state;

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        state <= (state == 1'b0 && j == 1'b1) ? 1'b1 :
                 (state == 1'b1 && k == 1'b1) ? 1'b0 : state;
    end
end

assign out = state;

endmodule