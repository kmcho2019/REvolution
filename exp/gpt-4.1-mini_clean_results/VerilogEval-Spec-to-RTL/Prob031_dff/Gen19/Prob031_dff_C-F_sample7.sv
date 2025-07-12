// D flip-flop module with positive edge-triggered nonblocking assignment
// Portable synthesis attribute (* keep = "true" *) hints preservation without vendor lock-in
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

// Top-level module instantiates the DFF, exposing a clean interface
module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    // Instantiate the D flip-flop with clean port connections
    DFF dff_inst (
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule