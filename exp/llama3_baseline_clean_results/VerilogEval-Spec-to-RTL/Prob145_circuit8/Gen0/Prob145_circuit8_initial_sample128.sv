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
end

always @(posedge clock) begin
    if (a) begin
        q_reg <= ~q_reg;
    end else begin
        q_reg <= q_reg;
    end
end

assign p = p_reg;
assign q = q_reg;

initial begin
    p_reg = 0;
    q_reg = 0;
end

endmodule