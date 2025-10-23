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
        state <= 0; // Reset to OFF state
    end else if (state == 0) begin
        state <= j? 1 : 0; // Transition from OFF to ON if j=1
    end else begin
        state <= k? 0 : 1; // Transition from ON to OFF if k=1
    end
end

assign out = state; // Output is the current state

endmodule