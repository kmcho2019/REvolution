module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q = 1'b0  // Initialize for simulation
);

always @(posedge clk) begin
    q <= r ? 1'b0 : d;  // Compact synchronous reset with ternary operator
end

endmodule