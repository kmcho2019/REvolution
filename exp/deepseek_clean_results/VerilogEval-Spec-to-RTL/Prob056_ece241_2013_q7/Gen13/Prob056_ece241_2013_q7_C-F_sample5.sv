module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;
wire Q_next = (j & ~Q_reg) | (~k & Q_reg);

always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule