module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

// Unified register implementation with parallel load
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= {8{1'b0}};  // Clear all bits using replication
    end else begin
        q <= d;           // Parallel load on clock edge
    end
end

endmodule