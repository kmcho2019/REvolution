module TopModule (
    input  clk,    // Clock input (positive edge triggered)
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output reg q    // Output register
);

// Synchronous D Flip-Flop with active-high reset
always @(posedge clk) begin
    if (r) begin
        q <= 1'b0;  // Reset condition
    end
    else begin
        q <= d;     // Normal operation
    end
end

endmodule