module TopModule(
    input clk,
    input a,
    output q
);

reg q_reg;
reg prev_a;

initial begin
    q_reg = 1'b1;
    prev_a = 1'bx;
end

always @(posedge clk) begin
    prev_a <= a;
    if (prev_a == 1'b0 && a == 1'b1) begin
        q_reg <= ~q_reg;
    end
end

assign q = q_reg;

endmodule