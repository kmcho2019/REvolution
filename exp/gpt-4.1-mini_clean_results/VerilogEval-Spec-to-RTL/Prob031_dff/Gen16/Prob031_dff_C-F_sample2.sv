// Dedicated D flip-flop module with positive-edge clock and nonblocking assignment
module DFF (
    input  wire clk,  // Clock input
    input  wire d,    // Data input
    output reg  q     // Data output (registered)
);
    // On positive edge of clock, sample d into q
    always @(posedge clk) begin
        q <= d;
    end
endmodule

// TopModule instantiates the DFF directly, minimal and synthesis friendly
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