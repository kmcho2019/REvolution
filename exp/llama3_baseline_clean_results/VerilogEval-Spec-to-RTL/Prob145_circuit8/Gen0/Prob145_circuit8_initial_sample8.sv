module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg;
reg q_reg;

always @(posedge clock) begin
    p_reg <= a;
    if (a) begin
        q_reg <= 1;
    end
end

always @(*) begin
    p = p_reg;
    q = q_reg;
end

initial begin
    p_reg = 0;
    q_reg = 0;
end

endmodule