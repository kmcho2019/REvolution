// Minimal D flip-flop module with positive edge-triggered nonblocking assignment
// No synthesis attributes to allow optimal power and area optimizations
module DFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

// TopModule instantiates the DFF with a clean, minimal interface
module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    // Direct instantiation of DFF with no extra logic or wiring
    DFF dff_inst (
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule