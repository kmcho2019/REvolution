module TopModule(
    input clk,
    input d,
    output reg q
);

reg stage1;

always @(posedge clk) begin
    stage1 <= d;
    q <= stage1;
end

endmodule