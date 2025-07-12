// D flip-flop module with positive edge clock trigger
// Nonblocking assignment used for correct synchronous operation
// Synthesis attribute hint for register inference (vendor-specific directives can be added here if needed)
module DFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

// Top-level module instantiating the DFF without additional logic
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