module TopModule (
    input  clk,    // Clock input
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output reg q   // Registered output
);

always @(posedge clk) begin
    // Reset has priority - synchronous to clock
    q <= r ? 1'b0 : d;
end

endmodule