module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

// Positive edge-triggered D flip-flop with asynchronous reset
// Behavior:
// 1. When ar is high, q is immediately reset to 0 (async, priority)
// 2. On rising clock edges when ar is low, q samples d
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;  // Active-high asynchronous reset
    end else begin
        q <= d;     // Normal clocked operation
    end
end

endmodule