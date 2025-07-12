module TopModule (
    input  wire clk,  // Positive edge-triggered clock
    input  wire ar,   // Asynchronous reset (active high)
    input  wire d,    // Data input
    output reg  q     // Registered output
);

// Alternative implementation using event control with continuous assignment
assign @(posedge clk or posedge ar) q = ar ? 1'b0 : d;

endmodule