module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

// Maintain simplicity and efficiency by directly incrementing the counter
// unless reset is high, leveraging the natural wrap-around of binary arithmetic.
always @(posedge clk) begin
    if (reset) begin
        // Explicitly reset the counter to 0 for clarity and good design practice
        q <= 4'd0; // Synchronous reset to 0
    end else begin
        // Direct incrementation maintains simplicity and efficiency.
        q <= q + 1;
    end
end

endmodule