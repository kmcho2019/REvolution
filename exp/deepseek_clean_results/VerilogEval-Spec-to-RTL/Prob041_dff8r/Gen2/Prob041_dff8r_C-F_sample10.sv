module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

// 8-bit register with synchronous reset
always @(posedge clk) begin
    if (reset) q <= 8'b0;  // Synchronous reset to zero
    else q <= d;           // Normal operation
end

endmodule