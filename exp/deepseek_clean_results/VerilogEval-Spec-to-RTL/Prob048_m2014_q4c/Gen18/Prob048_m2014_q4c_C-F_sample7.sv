module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q = 1'b0  // Initial value for simulation clarity
);

always @(posedge clk) begin
    q <= r ? 1'b0 : d;  // Compact synchronous reset implementation
end

endmodule