module TopModule (
    input  clk,  // Positive edge-triggered clock
    input  ar,   // Asynchronous reset (active high)
    input  d,    // Data input
    output reg q // Registered output
);

// Positive edge-triggered DFF with async reset
// Note: Consider clock gating if used in power-sensitive designs
always @(posedge clk or posedge ar)
    if (ar) q <= 1'b0;  // Async reset has priority
    else    q <= d;     // Data capture on rising clock

endmodule