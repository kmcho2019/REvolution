module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    q <= reset ? 4'b0001 :         // Reset to 1
         (q == 4'b1010) ? 4'b0001 : // Wrap at 10
         q + 1;                     // Normal increment
end

endmodule