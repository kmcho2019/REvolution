module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    Q <= (j & k) ? ~Q :  // Toggle when both are 1
         j ? 1'b1 :      // Set when J=1
         k ? 1'b0 :      // Reset when K=1
         Q;              // Hold when both are 0
end

endmodule