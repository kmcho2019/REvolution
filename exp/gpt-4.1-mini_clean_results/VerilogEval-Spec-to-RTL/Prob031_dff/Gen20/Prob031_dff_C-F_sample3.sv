// D flip-flop module implementing a positive-edge triggered DFF
// Nonblocking assignment ensures correct sequential behavior
// Optional synthesis attribute hints are included as comments for easy toggling
module DFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Uncomment the following line to preserve the flip-flop during synthesis (for debug or layout constraints)
    // (* keep = "true" *) 

    always @(posedge clk) begin
        q <= d;
    end
endmodule

// Top-level module instantiates the DFF with clean interface
// Keeps design minimal and modular, easily maintainable
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