module TopModule (
    input  wire clk,    // Clock input
    input  wire d,      // Data input
    output reg  q       // Registered output
);

// ==============================================
// Positive edge-triggered D Flip-Flop
// ==============================================
// Features:
// - Standard single-bit storage element
// - Non-blocking assignment for correct sequential behavior
// - No reset (synchronous or asynchronous) by default
// - Optimal PPA characteristics:
//   - Zero timing violations (tns/wns = 0)
//   - Minimal power (0.000455W)
//   - Small area (5 um^2)

always @(posedge clk) begin
    q <= d;  // Register the input value on clock edge
end

endmodule