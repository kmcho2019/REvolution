module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

// Given the existing design is straightforward and efficient, we maintain the simplicity
// of directly incrementing the counter within a single always block.
always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 0, maintaining efficiency and simplicity.
        q <= 4'd0;
    end else begin
        // Direct incrementation is already optimized for performance and area.
        // This operation naturally wraps around due to binary arithmetic.
        q <= q + 1'd1;
    end
end

endmodule