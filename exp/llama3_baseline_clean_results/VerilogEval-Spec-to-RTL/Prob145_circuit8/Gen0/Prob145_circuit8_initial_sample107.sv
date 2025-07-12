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
    q_reg <= q_reg;
end

always @(negedge clock) begin
    if (a == 1) begin
        p_reg <= 1;
        q_reg <= 1;
    end
end

assign p = p_reg;
assign q = q_reg;

initial begin
    p_reg = 0;
    q_reg = 0;
end

endmodule