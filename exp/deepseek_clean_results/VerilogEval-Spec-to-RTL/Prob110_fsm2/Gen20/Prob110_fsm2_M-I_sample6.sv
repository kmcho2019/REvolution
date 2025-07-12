module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg state;  // 0=OFF, 1=ON

// Combined sequential logic with direct state transitions
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0;  // Reset to OFF state
    end else begin
        state <= (state == 1'b0) ? j : ~k;
    end
end

assign out = state;  // Direct output from state

endmodule