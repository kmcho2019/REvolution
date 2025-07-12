module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_reg;

always @(posedge clk) begin
    q_reg <= d;
end

always @(negedge clk) begin
    q <= ~q_reg;
end

assign q = (clk)? q_reg : ~q_reg;

endmodule