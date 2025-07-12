module TopModule (
    input  clk,    // Clock input (positive edge triggered)
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output reg q = 1'b0  // Output register with explicit initialization
);

// Synchronous D Flip-Flop with active-high reset and clock gating
// Explicit reset priority for better readability
always @(posedge clk) begin
    if (r) begin       // Reset has priority
        q <= 1'b0;
    end
    else begin         // Normal operation
        q <= d;
    end
end

endmodule