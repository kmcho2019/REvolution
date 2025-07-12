module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

parameter RESET_POLARITY = 1'b1; // 1=active high, 0=active low
parameter USE_CLOCK_GATING = 1'b0; // Enable for power optimization

reg gated_clk;

generate
    if (USE_CLOCK_GATING) begin : CLK_GATING
        // Simple clock gating - in real design would use library clock gating cell
        always @(*) begin
            gated_clk = clk & (ar != RESET_POLARITY);
        end
    end else begin : NO_CLK_GATING
        always @(*) gated_clk = clk;
    end
endgenerate

always @(posedge gated_clk or posedge ar) begin
    if (ar == RESET_POLARITY) q <= 1'b0;  // Configurable reset polarity
    else                     q <= d;      // Positive edge-triggered data capture
end

endmodule