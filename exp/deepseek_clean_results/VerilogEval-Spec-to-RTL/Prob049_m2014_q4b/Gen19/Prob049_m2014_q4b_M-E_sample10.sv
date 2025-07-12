module TopModule (
    input  wire clk,
    input  wire ar,
    input  wire d,
    output wire q
);

wire master_out;    // Master latch output
wire slave_out;     // Slave latch output
wire reset_clamped; // Reset-controlled output

// Master latch (negative level-sensitive)
assign master_out = (~clk) ? d : master_out;

// Slave latch (positive level-sensitive)
assign slave_out = clk ? master_out : slave_out;

// Reset control mux (async reset has priority)
assign reset_clamped = ar ? 1'b0 : slave_out;

// Output assignment
assign q = reset_clamped;

endmodule