module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg;
assign p = p_reg;

always @(posedge clock) begin
    if (a == 1'b1) begin
        p_reg <= 1'b1;
    end else begin
        p_reg <= 1'b0;
    end
end

assign q = ~clock & p;

endmodule