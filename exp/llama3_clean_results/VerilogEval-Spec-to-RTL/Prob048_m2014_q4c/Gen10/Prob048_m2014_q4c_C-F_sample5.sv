module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    // Using a simple and efficient synchronous reset mechanism
    // with a ternary operator for concise expression and clarity
    q <= (r) ? 1'b0 : d;
end

endmodule