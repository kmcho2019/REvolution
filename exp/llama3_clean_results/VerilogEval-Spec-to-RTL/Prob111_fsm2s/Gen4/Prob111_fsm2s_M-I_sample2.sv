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
        if (state == 1'b0) begin
            state <= j? 1'b1 : 1'b0; // Transition from OFF
        end else begin
            state <= ~k? 1'b1 : 1'b0; // Transition from ON
        end
    end
end

assign out = state;

endmodule