// Dedicated D flip-flop module with positive edge-triggered nonblocking assignment
// Lightweight synthesis attribute to hint register preservation without vendor lock-in
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

// TopModule instantiates DFF directly with clean interface
module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    // Instantiate the DFF primitive without extra wiring
    DFF dff_inst (
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule