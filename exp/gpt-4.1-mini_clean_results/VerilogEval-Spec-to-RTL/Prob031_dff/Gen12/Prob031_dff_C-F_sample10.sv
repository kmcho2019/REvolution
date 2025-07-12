// Dedicated DFF module with positive-edge triggered nonblocking assignment
// Includes synthesis attribute to hint register preservation without vendor locking
module DFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Attribute to encourage tool to keep register during optimizations
    (* keep = "true" *)
    always @(posedge clk) begin
        q <= d;
    end
endmodule

// TopModule instantiates the DFF module with exact specified interface
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