// Minimal D flip-flop module with positive edge-triggered nonblocking assignment
// Gentle synthesis attribute hint to preserve the register if desired;
// remove or comment out for stricter power/area optimization.
module DFF (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // syn_preserve: mild hint to synthesis tools to keep this register
    // This attribute can be removed to allow more aggressive optimization
    (* syn_preserve = "true" *)
    always @(posedge clk) begin
        q <= d;
    end
endmodule

// Top-level module instantiates the DFF directly with a clean interface.
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