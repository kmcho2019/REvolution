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

always @(posedge clock or negedge clock) begin
    if (!clock && p_reg) begin
        q_reg <= 1'b1;
    end else if (clock && !a) begin
        q_reg <= 1'b0;
    end
end

assign p = p_reg;
assign q = q_reg;

endmodule