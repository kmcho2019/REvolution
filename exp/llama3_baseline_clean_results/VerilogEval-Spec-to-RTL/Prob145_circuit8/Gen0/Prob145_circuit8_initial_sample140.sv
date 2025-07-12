module TopModule(
    input  clock,
    input  a,
    output p,
    output q
);

reg p_reg = 0;
reg q_reg = 0;

always @(posedge clock) begin
    p_reg <= a;
end

always @(negedge clock) begin
    if (a) begin
        q_reg <= 1;
    end
    if (!a && p_reg) begin
        q_reg <= 0;
    end
end

assign p = p_reg;
assign q = q_reg;

endmodule