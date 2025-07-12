module TopModule(
    input  clk,
    input  d,
    output reg q
);

reg internal_clk;

always @(posedge clk or negedge clk) begin
    internal_clk <= ~internal_clk;
end

always @(posedge internal_clk) begin
    q <= d;
end

endmodule