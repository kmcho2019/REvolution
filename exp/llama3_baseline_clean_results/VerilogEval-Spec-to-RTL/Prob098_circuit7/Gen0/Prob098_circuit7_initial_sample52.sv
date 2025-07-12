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
    if (a == 1'b1) begin
        q_reg <= ~q_reg;
    end else begin
        q_reg <= q_reg;
    end
end

assign q = q_reg;

endmodule