module TopModule(
    input clk,
    input d,
    output q
);

reg q_reg;
reg q2_reg;
reg last_clk;

always @(posedge clk) begin
    last_clk <= 1'b1;
    q_reg <= d;
end

always @(negedge clk) begin
    last_clk <= 1'b0;
    q2_reg <= d;
end

assign q = (last_clk == 1'b1) ? q_reg : q2_reg;

endmodule