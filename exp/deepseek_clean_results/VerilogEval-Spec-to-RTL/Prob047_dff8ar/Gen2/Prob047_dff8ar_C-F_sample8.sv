module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

// Clock gating control (simplified for this example)
// In a real design, this would be more sophisticated
wire clk_enable = (q != d); // Only enable clock when data changes

// Main register with async reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 8'b0;         // Async reset to 0
    end else if (clk_enable) begin
        q <= d;            // Clock gated update
    end
end

endmodule