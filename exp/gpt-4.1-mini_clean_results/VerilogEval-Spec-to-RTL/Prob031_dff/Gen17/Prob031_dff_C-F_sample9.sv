// D flip-flop with positive edge clock trigger
// Nonblocking assignment ensures proper synchronous behavior
// Vendor-neutral synthesis attribute comment to guide register inference (optional)
module DFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // synthesis attribute register "true" of q is "true"; // Vendor-neutral hint for synthesis tools (adjust if needed)

    always @(posedge clk) begin
        q <= d;
    end
endmodule

// Top-level module matching the specified interface and instantiating the DFF
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