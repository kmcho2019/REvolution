module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

// Maintain simplicity and efficiency by directly updating the counter
// unless reset is high, leveraging the natural wrap-around of binary arithmetic.
always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 0, ensuring minimal switching activity.
        q <= 4'd0;
    end else begin
        // Direct incrementation maintains simplicity and efficiency.
        q <= q + 1;
    end
end

endmodule