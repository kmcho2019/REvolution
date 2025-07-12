module TopModule (
    input        clk,     // Clock input (positive edge triggered)
    input        areset,  // Asynchronous reset (active high)
    input  [7:0] d,       // 8-bit data input
    output reg [7:0] q    // 8-bit registered output
);

// 8-bit register with asynchronous reset
// Features:
// - Positive edge clock triggering
// - Active high asynchronous reset (resets all bits to 0)
// - Parallel processing of all 8 bits
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 8'b00000000;  // Clear all bits on reset
    end else begin
        q <= d;            // Capture input on rising clock edge
    end
end

endmodule