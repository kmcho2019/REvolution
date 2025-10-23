module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

reg prev_clk;
wire clk_rise = clk & ~prev_clk;

always @(*) begin
    prev_clk <= clk;
end

always @(*) begin
    if (clk_rise) begin
        q <= r ? 1'b0 : d;
    end
end

endmodule