module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

localparam WIDTH = 4;

// 4-bit synchronous binary counter with active-high synchronous reset
// Increment only when not resetting to reduce unnecessary toggling
always @(posedge clk) begin
    if (reset)
        q <= {WIDTH{1'b0}};      // Reset counter to 0
    else
        q <= q + 1'b1;           // Increment counter by 1 (mod 16)
end

endmodule