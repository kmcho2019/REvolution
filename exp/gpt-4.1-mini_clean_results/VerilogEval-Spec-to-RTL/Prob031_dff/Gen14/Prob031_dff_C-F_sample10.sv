// Minimal D flip-flop module with positive edge-triggered nonblocking assignment
// Synthesis attribute included as a generic hint to infer a register for improved tool recognition
module DFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Generic synthesis attribute to preserve register inference
    (* keep = "true" *) 
    always @(posedge clk) begin
        q <= d;
    end
endmodule

// TopModule instantiates the DFF to maintain modularity and clear interface
module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    // Instantiate the DFF module
    DFF dff_inst (
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule