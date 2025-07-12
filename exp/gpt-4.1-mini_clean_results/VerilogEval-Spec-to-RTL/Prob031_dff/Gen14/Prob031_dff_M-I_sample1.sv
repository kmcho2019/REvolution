// Simple D flip-flop with positive edge clock trigger
// Nonblocking assignment ensures proper sequential behavior
// Synthesis directive included to guide register inference
module DFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // synthesis attribute register of q is "true"; // Synopsys example attribute for register inference
    
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