module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;
reg enable = 1'b1;  // Default enabled, can be controlled externally if needed

always @(posedge clk) begin
    if (areset) begin
        q_reg <= 8'b0;         // Synchronous reset all bits to 0
    end
    else if (enable) begin     // Clock gating for power reduction
        q_reg <= d;            // Parallel assignment on clock edge
    end
end

assign q = q_reg;  // Buffered output for better drive strength

endmodule