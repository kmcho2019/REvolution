module TopModule(
    input clk,
    input d,
    output q
);

reg q_reg;
reg q_reg2;

always @(posedge clk) begin
    q_reg <= d;
end

always @(negedge clk) begin
    q_reg2 <= d;
end

assign q = (clk == 1'b1) ? q_reg : q_reg2;

endmodule