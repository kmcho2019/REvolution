// D flip-flop module with positive edge-triggered nonblocking assignment
// Portable synthesis attribute (* keep = "true" *) hints register preservation without vendor lock-in
module DFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    (* keep = "true" *)
    always @(posedge clk) begin
        q <= d;
    end
endmodule

// Top-level module implementing the specified interface, instantiating the reusable DFF
module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    // Instantiate DFF to implement the single-bit D flip-flop
    DFF dff_inst (
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule