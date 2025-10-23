module TopModule(
    input  clk,
    input  d,
    output reg q
);

reg d_delayed;

always @(posedge clk) begin
    d_delayed <= d;
end

always @(negedge clk) begin
    q <= d_delayed;
end

// Alternatively, you can also implement it as follows:
// always @(posedge clk) begin
//     q <= d;
// end
// 
// always @(negedge clk) begin
//     q <= d;
// end
// However, this implementation assumes that 'd' is stable across both edges,
// which in many cases, it is not.

endmodule