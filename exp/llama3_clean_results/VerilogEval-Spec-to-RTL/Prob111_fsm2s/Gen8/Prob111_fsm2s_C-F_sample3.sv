module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else if (state == 1'b0) begin // Currently in OFF state
        state <= j? 1'b1 : 1'b0; // Transition to ON state if j is 1
    end else begin // Currently in ON state
        state <= ~k? 1'b1 : 1'b0; // Stay in ON state if k is 0, otherwise transition to OFF
    end
end

assign out = state;

endmodule