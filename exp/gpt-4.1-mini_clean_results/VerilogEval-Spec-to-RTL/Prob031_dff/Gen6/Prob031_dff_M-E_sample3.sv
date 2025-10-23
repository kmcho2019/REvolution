module TopModule(
    input clk,
    input d,
    output q
);

reg d_reg;

always @(posedge clk) begin
    d_reg <= d;
end

assign q = d_reg;

endmodule