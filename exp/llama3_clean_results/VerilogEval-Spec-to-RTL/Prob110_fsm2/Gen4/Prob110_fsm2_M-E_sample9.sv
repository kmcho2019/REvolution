module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg state; // 1-bit signal to represent the current state

always @(posedge areset or posedge clk) begin
    if(areset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        // State transitions using binary arithmetic
        state <= (state == 1'b0 && j == 1'b1) ? 1'b1 :
                 (state == 1'b1 && k == 1'b1) ? 1'b0 : state;
    end
end

assign out = state; // Output is directly based on the current state

endmodule