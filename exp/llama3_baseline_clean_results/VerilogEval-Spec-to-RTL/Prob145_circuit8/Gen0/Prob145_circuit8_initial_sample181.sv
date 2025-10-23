module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg;
reg q_reg;

assign p = (clock == 1'b1) ? a : 1'b0;

always @(posedge clock) begin
    if (a == 1'b1) begin
        q_reg <= 1'b1;
    end else begin
        q_reg <= q_reg;
    end
end

always @(negedge clock) begin
    q_reg <= 1'b0;
end

assign q = q_reg;

endmodule