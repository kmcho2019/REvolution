module TopModule (
    input  clk,    // Clock input
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output q       // Output
);

reg q_reg = 1'b0;  // Internal register with explicit reset value

// Positive edge-triggered D flip-flop with synchronous reset
always @(posedge clk) begin
    if (r) begin
        q_reg <= 1'b0;  // Reset condition
    end
    else begin
        q_reg <= d;     // Normal operation
    end
end

// Continuous assignment for output
assign q = q_reg;

endmodule