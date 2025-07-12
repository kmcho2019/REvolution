// Dedicated D flip-flop module with positive edge-triggered nonblocking assignment
// Correctly models synchronous DFF behavior for synthesis and simulation
module DFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Trigger on positive edge of clock: standard flip-flop behavior
    always @(posedge clk) begin
        q <= d;
    end
endmodule

// Top-level module instantiates DFF directly with clean interface
// Keeps hierarchy simple and synthesis-friendly with no extra logic
module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    // Instantiate single D flip-flop
    DFF dff_inst (
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule