module TopModule(
    input  clock,
    input  a,
    output p,
    output q
);

reg p_reg;
reg q_reg;

always @(posedge clock) begin
    p_reg <= a;
    if (a) begin
        q_reg <= 1'b1;
    end else begin
        q_reg <= q_reg;
    end
end

assign p = p_reg;
assign q = (clock == 1'b0) ? (a ? 1'b1 : q_reg) : q_reg;

initial begin
    p_reg = 1'b0;
    q_reg = 1'b0;
end

endmodule