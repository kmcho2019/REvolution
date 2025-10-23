module TopModule(
    input clk,
    input d,
    output q
);

reg internal_clk;
assign internal_clk = clk ^ ~clk;

reg q_reg;
always @(posedge internal_clk) begin
    q_reg <= d;
end

assign q = q_reg;

endmodule