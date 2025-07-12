module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    q <= (r) ? 1'b0 : d; // Use ternary operator for concise logic
end

endmodule