module TopModule (
    input  clk,  // Positive edge clock
    input  ar,   // Asynchronous reset (active high)
    input  d,    // Data input
    output reg q // Registered output
);

// Positive edge-triggered DFF with async reset
// Note: Clock gating could be added if 'd' is stable for multiple cycles
always @(posedge clk or posedge ar)
    if (ar) q <= 1'b0; // Async reset
    else    q <= d;    // Normal operation

endmodule