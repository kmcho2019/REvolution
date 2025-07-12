module TopModule(
    input  clock,
    input  a,
    output p,
    output q
);

reg q_reg;

always @(posedge clock) begin
    if (a) begin
        q_reg <= 1;
    end else begin
        q_reg <= q_reg;
    end
end

assign p = a & clock;
assign q = (clock ? a : q_reg);

endmodule