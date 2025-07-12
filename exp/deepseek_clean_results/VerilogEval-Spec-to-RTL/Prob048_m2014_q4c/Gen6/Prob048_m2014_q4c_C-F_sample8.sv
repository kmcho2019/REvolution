module TopModule (
    input  clk,    // Clock input (positive edge triggered)
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output reg q = 1'b0  // Output register with initialization
);

always @(posedge clk) begin
    q <= r ? 1'b0 : d;  // Compact reset logic with clear priority
end

endmodule