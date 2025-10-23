// D flip-flop module with positive edge clock trigger
// Nonblocking assignment used for correct synchronous operation
// Synthesis attribute hint (vendor-neutral comment) for standard register inference
module DFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // synthesis attribute keep "true" of q is set here to hint keeping the register (optional)
    // synthesis attribute register "true" of q is set here to hint it is a register (vendor-specific usage may vary)
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