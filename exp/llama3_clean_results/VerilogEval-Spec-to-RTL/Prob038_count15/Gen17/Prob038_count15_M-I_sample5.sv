module TopModule(
    input clk,
    input reset,
    input enable, // New input to control clock gating
    output reg [3:0] q
);

// Retain simplicity and efficiency by directly incrementing the counter
// within a single always block, leveraging the natural wrap-around of binary arithmetic.
always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 0, which is straightforward and efficient.
        q <= 4'd0;
    end else if (enable) begin
        // Direct incrementation maintains simplicity and efficiency.
        // This operation is already optimized for performance and area.
        q <= q + 1'd1;
    end
end

endmodule