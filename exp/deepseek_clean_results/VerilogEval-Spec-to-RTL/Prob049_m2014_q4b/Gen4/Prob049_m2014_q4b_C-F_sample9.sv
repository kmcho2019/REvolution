module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

// Positive edge-triggered D flip-flop with asynchronous reset
// Priority behavior:
// 1. When ar is high, q immediately resets to 0 (highest priority)
// 2. On rising clock edges when ar is low, q samples d
always @(posedge clk or posedge ar)
    if (ar) q <= 1'b0;  // Active-high async reset
    else    q <= d;     // Normal clocked operation

endmodule