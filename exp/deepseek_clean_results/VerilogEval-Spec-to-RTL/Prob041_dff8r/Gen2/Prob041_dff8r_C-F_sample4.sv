module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

// 8-bit register with synchronous reset
// All flip-flops update on rising clock edge
// Active-high reset clears all bits to 0
always @(posedge clk) begin
    q <= reset ? 8'b0 : d;  // Compact reset logic
end

endmodule