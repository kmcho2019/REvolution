module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

always @(posedge clk) begin
    if (reset) begin
        out <= 0; // Reset to OFF state
    end else if (out == 0) begin
        out <= j; // Transition from OFF to ON if j=1
    end else begin
        out <= ~k; // Stay in ON if k=0, transition to OFF if k=1
    end
end

endmodule