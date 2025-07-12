module TopModule(
    input clk,
    input d,
    output q
);

reg d_reg;
reg q_reg;
reg clk_ff;

always @(posedge clk)
    d_reg <= d;

always @(negedge clk)
    clk_ff <= ~clk_ff;

always @(posedge clk_ff)
    q_reg <= d_reg;

assign q = q_reg;

initial begin
    d_reg = 0;
    q_reg = 0;
    clk_ff = 0;
end

endmodule