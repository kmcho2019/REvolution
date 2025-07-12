module TopModule (
    input  clk,    // Clock input
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output reg q   // Output register
);

wire next_q;  // Mux output before registration

// Explicit multiplexer implementation
assign next_q = r ? 1'b0 : d;

// Clock gating could be inserted here in more complex designs
always @(posedge clk) begin
    q <= next_q;
end

// Initialize q for simulation (synthesis will ignore)
initial begin
    q = 1'b0;
end

endmodule