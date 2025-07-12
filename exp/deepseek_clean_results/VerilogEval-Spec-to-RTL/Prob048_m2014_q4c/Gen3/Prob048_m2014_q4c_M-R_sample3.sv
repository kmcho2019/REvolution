module TopModule (
    input  clk,    // Clock input
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output q       // Output
);

reg q_reg = 1'b0;  // Internal register with initialization

// Continuous assignment version of DFF with sync reset
assign q = q_reg;

always @(posedge clk) begin
    q_reg <= r ? 1'b0 : d;
end

endmodule