module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Single flip-flop for OFF (0) and ON (1) states

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to OFF state
    end else if (state == 0) begin
        state <= j; // Transition from OFF to ON if j is 1
    end else begin
        state <= ~k; // Stay in ON state if k is 0, otherwise transition to OFF
    end
end

assign out = state; // Directly assign state to output

endmodule