/**
 * 8-bit register with synchronous reset
 * Resets all bits to 0 on rising clock edge when reset is high
 */
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (reset) q <= 8'b0;  // Synchronous reset
    else       q <= d;      // Normal operation
end

endmodule