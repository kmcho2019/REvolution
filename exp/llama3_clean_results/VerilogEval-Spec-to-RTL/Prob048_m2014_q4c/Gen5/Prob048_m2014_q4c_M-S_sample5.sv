module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    q <= r ? 0 : d; // Simplified ternary operator for reset and data assignment
end

endmodule