module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    q <= reset ? 4'b0000 :          // Synchronous reset
         (q[3] & q[0]) ? 4'b0000 :  // Efficient check for 9 (1001)
         q + 1'b1;                  // Normal increment
end

endmodule