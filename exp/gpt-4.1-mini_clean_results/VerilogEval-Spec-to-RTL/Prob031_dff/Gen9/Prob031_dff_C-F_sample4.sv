// Simple D flip-flop module with positive edge clock trigger
// Uses nonblocking assignment for proper sequential logic behavior
module DFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Synthesis attribute hint: infer as a register (vendor-specific directives can be added if needed)
    always @(posedge clk) 
        q <= d;
endmodule

// Top-level module instantiates the DFF directly without additional logic
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