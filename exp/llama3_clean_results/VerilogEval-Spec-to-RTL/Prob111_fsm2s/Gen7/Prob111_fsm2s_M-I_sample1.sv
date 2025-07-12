module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

always @(posedge clk) begin
    if (reset) begin
        out <= 1'b0; // Reset to OFF state
    end else if (out == 1'b0) begin
        out <= j; // Transition from OFF
    end else begin
        out <= ~k; // Transition from ON
    end
end

endmodule