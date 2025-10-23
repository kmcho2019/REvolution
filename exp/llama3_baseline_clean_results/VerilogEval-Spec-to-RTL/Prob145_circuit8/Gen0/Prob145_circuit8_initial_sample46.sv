module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg = 0;
reg q_reg = 0;

always @ (posedge clock) begin
    if (a) begin
        p_reg <= 1;
    end else begin
        p_reg <= 0;
    end
end

always @ (posedge clock) begin
    if (p_reg) begin
        q_reg <= 1;
    end else if (~clock) begin
        q_reg <= 0;
    end
end

assign p = p_reg;
assign q = q_reg;

endmodule