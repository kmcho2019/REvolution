module TopModule(
    input clk,
    input d,
    output q
);

reg q_reg;
reg t_reg;

always @(posedge clk) begin
    t_reg <= d ^ q_reg;
    q_reg <= t_reg ? ~q_reg : q_reg;
end

assign q = q_reg;

endmodule