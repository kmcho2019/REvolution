module TopModule(
    input  clk,
    input  d,
    output q
);

reg internal_clk;
reg q_reg;

initial begin
    internal_clk = 0;
    q_reg = 0;
end

always @(posedge clk or negedge clk) begin
    internal_clk = ~internal_clk;
end

always @(posedge internal_clk) begin
    q_reg <= d;
end

assign q = q_reg;

endmodule