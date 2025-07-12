// Positive-edge triggered D flip-flop with asynchronous reset
module TopModule (
    input clk,
    input ar,
    input d,
    output reg q = 1'b0  // Initialize to 0 for clarity
);

always @(posedge clk or posedge ar)
    if (ar) q <= 1'b0;    // Asynchronous reset
    else    q <= d;       // Positive-edge data capture

endmodule