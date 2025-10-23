module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A (1) and state B (0)

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // Reset to state A
    end else begin
        state <= (state == 1'b1 && x) || (state == 1'b0);
    end
end

assign z = (state == 1'b1)? x : ~x;

endmodule