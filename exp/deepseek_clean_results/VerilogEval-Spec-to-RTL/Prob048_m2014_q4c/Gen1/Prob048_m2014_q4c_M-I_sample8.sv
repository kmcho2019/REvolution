module TopModule (
    input clk,
    input d,
    input r,
    output reg q = 1'b0  // Explicit initial value
);

always @(posedge clk) begin
    q <= r ? 1'b0 : d;  // Ternary operator for conciseness
end

endmodule