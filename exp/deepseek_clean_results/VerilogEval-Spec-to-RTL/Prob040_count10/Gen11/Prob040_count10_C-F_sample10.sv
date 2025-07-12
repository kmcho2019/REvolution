module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    q <= reset ? 4'b0000 :          // Synchronous reset
         (q == 4'b1001) ? 4'b0000 : // Clear terminal count (9)
         q + 1'b1;                 // Increment otherwise
end

endmodule