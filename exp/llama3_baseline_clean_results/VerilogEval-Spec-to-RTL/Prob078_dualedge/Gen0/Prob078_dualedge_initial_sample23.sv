module TopModule(
    input  clk,
    input  d,
    output reg q
);

reg old_clk;

always @(*) begin
    if (clk != old_clk) begin
        q <= d;
    end
    old_clk <= clk;
end

endmodule