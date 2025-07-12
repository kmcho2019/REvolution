module TopModule(
    input clk,
    input d,
    output q
);

reg q_reg;
reg q_ff;

always @(posedge clk) begin
    q_ff <= d;
end

always @(negedge clk) begin
    q_reg <= q_ff;
end

assign q = (clk)? q_ff : q_reg;

endmodule