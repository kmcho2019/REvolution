module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

// Using a single always block with vector operations
// for more compact implementation
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 8'b0;  // Single reset operation for all bits
    end
    else begin
        q <= d;     // Parallel assignment for all bits
    end
end

endmodule