module TopModule (
    input  wire clk,  // Positive edge-triggered clock
    input  wire ar,   // Asynchronous reset (active high)
    input  wire d,    // Data input
    output reg  q     // Registered output
);

// Positive edge-triggered DFF with async reset
// Note: Consider clock gating if 'd' remains stable for multiple cycles
always @(posedge clk or posedge ar)
    if (ar) q <= 1'b0;  // Highest priority async reset
    else    q <= d;     // Normal data capture

endmodule