module TopModule(
    input  clk,
    input  d,
    output q
);

reg q_reg;
reg prev_clk;

always @(posedge clk or negedge clk) begin
    if (clk != prev_clk) begin
        prev_clk <= clk;
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule