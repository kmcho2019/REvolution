module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

reg Q_reg;
always @(posedge clk) Q_reg <= L ? R : E ? w : Q_reg;
assign Q = Q_reg;

endmodule