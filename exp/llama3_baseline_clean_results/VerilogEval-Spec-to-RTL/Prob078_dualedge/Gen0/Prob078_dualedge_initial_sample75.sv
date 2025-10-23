module TopModule(
    input  clk,
    input  d,
    output q
);

reg clk_en;
reg q_reg;

always @(posedge clk or negedge clk) begin
    clk_en <= ~clk_en;
end

always @(posedge clk) begin
    if (clk_en) begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule