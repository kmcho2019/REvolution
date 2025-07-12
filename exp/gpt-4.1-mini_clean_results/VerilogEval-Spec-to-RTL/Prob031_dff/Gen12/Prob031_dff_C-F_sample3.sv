// Simple D flip-flop with positive edge clock trigger
// Nonblocking assignment ensures proper sequential behavior
// Synthesis directive included to guide register inference
module DFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // synthesis attribute equivalent_register "yes" of q is "true"; // Vendor-specific directive example (commented, adjust if needed)

    always @(posedge clk) 
        q <= d;
endmodule

// Top-level module instantiates the DFF without extra logic
module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    DFF dff_inst (
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule