// D flip-flop module with conditional nonblocking assignment to reduce toggling power
// Synthesis attribute hint (vendor-neutral comment) retained for standard register inference
module DFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    always @(posedge clk) begin
        if (d != q) begin
            q <= d;
        end
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