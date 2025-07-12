module TopModule(
    input clk,
    input d,
    output reg q
);

reg clk_div2;
reg d_shift;

always @(posedge clk) begin
    clk_div2 <= ~clk_div2;
    d_shift <= d;
end

always @(posedge clk_div2 or negedge clk_div2) begin
    q <= d_shift;
end

endmodule