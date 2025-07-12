module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

reg Q_reg;
assign Q = Q_reg;

always @(posedge clk) begin
    Q_reg <= L ? R : (E ? w : Q_reg);
end

endmodule