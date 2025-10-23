module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

always_ff @(posedge clk) begin
    if (reset) begin
        out <= 0; // Reset to OFF state
    end else if (out) begin
        out <= ~k; // Stay in ON state if k is 0, otherwise transition to OFF
    end else begin
        out <= j; // Transition from OFF to ON if j is 1
    end
end

endmodule