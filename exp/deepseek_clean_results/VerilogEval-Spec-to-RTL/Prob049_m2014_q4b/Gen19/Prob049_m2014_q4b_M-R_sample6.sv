module TopModule (
    input  wire clk,  // Positive edge-triggered clock
    input  wire ar,   // Asynchronous reset (active high)
    input  wire d,    // Data input
    output wire q     // Registered output (now wire type)
);

// Continuous assignment version with event control
assign #1 q = (ar) ? 1'b0 : (posedge clk) ? d : q;

endmodule