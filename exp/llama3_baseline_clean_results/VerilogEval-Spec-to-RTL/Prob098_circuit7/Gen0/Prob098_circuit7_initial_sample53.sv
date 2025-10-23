module TopModule(
    input  clk,
    input  a,
    output q
);

reg q_reg;
assign q = q_reg;

initial q_reg = 1'b1;

always @(posedge clk) begin
    if(a) begin
        q_reg <= ~q_reg;
    end
end

endmodule