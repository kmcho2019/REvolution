module TopModule (
    input clk,
    input d,
    output q
);

reg q_reg;
wire clk_posedge = clk & ~$past(clk);

always @* begin
    if (clk_posedge)
        q_reg = d;
end

assign q = q_reg;

endmodule