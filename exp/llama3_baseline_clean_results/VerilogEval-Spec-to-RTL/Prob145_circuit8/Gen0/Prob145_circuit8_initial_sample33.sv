module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg p_reg;
reg q_reg;

assign p = p_reg;
assign q = q_reg;

always @(*) begin
    if (clock) begin
        p_reg = a;
    end
end

always @(posedge clock) begin
    if (p_reg) begin
        q_reg <= 1'b1;
    end else if (~clock) begin
        q_reg <= p_reg;
    end
end

endmodule