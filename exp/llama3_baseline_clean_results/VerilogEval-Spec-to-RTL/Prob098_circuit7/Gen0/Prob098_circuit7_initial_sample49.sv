module TopModule(
    input clk,
    input a,
    output q
);

reg q_reg;

initial begin
    q_reg = 1'b1;
end

always @(posedge clk) begin
    q_reg <= q_reg ^ a;
end

assign q = q_reg;

endmodule