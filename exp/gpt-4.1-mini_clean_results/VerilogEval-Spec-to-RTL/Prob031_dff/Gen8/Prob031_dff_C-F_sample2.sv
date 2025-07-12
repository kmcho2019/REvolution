// Minimal D flip-flop module with positive edge-triggered nonblocking assignment
// Synthesis attribute included as a generic hint to infer a register
module DFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Synthesis attribute hint to infer a flip-flop/register
    // This can be adapted or extended with vendor-specific pragmas if needed
    (* keep = "true" *) 
    always @(posedge clk)
        q <= d;
endmodule

// TopModule instantiates the DFF to separate concerns and maintain modularity
module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    // Instantiate DFF, connecting inputs and outputs directly
    DFF dff_inst (
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule