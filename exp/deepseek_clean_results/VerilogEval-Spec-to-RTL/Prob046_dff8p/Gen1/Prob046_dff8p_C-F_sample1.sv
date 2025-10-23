module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

// 8 DFFs with synchronous reset to 0x34 (8'b00110100)
always @(negedge clk) begin
    if (reset) begin
        q <= 8'h34;  // Reset to 00110100 (0x34)
    end else begin
        q <= d;      // Normal operation
    end
end

endmodule