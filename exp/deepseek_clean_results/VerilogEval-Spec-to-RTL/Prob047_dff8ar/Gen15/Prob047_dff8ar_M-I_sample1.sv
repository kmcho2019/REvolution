module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

// Implement 8 DFFs with async reset directly in the module
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 8'b0;  // Async reset to 0
    end
    else begin
        q <= d;     // Synchronous data capture
    end
end

endmodule