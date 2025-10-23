module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg;
reg q_reg;

initial begin
    p_reg = 0;
    q_reg = 0;
end

always @(posedge clock) begin
    p_reg <= a;
end

always @(negedge clock) begin
    if (p_reg == 1) begin
        q_reg <= 1;
    end else begin
        q_reg <= 0;
    end
end

assign p = p_reg;
assign q = q_reg;

endmodule