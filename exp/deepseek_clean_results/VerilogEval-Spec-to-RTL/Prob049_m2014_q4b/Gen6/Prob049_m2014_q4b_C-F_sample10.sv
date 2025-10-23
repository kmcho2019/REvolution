module TopModule (
    input clk,        // Positive edge clock
    input ar,         // Asynchronous active-high reset
    input d,          // Data input
    output reg q      // Registered output
);

// Positive-edge triggered DFF with async reset
always @(posedge clk or posedge ar)
    if (ar) q <= 1'b0;  // Async reset has priority
    else    q <= d;      // Normal operation

endmodule