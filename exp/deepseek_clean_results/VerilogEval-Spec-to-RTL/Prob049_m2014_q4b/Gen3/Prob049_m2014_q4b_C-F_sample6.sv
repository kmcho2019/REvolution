module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

// Positive edge-triggered D flip-flop with async reset
always @(posedge clk or posedge ar)
    if (ar) q <= 1'b0;  // Async reset has priority
    else    q <= d;     // Normal operation: latch input on rising clock edge

endmodule