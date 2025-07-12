// Simple D flip-flop with positive edge clock trigger
// Uses nonblocking assignment for correct sequential behavior
// Synthesis tools will infer this as a standard register
module DFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    always @(posedge clk) 
        q <= d;
endmodule

// Top-level module instantiates the DFF without extra logic or signals
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