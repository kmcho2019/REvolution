module TopModule(
    input  clk,
    input  d,
    output q
);

reg q_reg;
reg d_reg;

always @(posedge clk) begin
    d_reg <= d;
end

always @(negedge clk) begin
    q_reg <= d_reg;
end

assign q = q_reg;

endmodule