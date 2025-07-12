// Dedicated D flip-flop module with positive edge-triggered nonblocking assignment
// Includes a synthesis attribute to gently hint preservation of the register
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

// TopModule instantiates DFF directly, passing signals with clean interface
module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    // Instantiate the DFF module, connecting inputs and outputs directly
    DFF dff_inst (
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule