module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// 4-bit binary counter with synchronous active-high reset
// Counts from 0 to 15 inclusive, then wraps around
always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else
        q <= q + 4'd1;
end

endmodule