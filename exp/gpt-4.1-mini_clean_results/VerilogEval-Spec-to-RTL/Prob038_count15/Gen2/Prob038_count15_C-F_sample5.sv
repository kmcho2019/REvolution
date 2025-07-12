module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// 4-bit binary counter with synchronous active-high reset
always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;    // Reset counter to 0
    else
        q <= q + 4'd1;   // Increment counter by 1, wrap naturally at 15 -> 0
end

endmodule