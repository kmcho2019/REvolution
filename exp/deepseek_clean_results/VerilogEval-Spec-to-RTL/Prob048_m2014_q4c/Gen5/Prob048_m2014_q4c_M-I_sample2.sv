module TopModule (
    input  clk,    // Clock input
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output reg q = 1'b0  // Output with explicit reset value
);

// Positive edge-triggered D flip-flop with synchronous reset
always @(posedge clk) begin
    if (r) begin
        q <= 1'b0;  // Reset condition
    end
    else begin
        q <= d;     // Normal operation
    end
end

endmodule