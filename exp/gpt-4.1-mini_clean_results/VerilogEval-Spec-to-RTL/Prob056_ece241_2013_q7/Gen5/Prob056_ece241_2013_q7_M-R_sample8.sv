module TopModule(
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;
wire Q_next;

assign Q = Q_reg;
assign Q_next = (j & ~Q_reg) | (~k & Q_reg);

always @(posedge clk) begin
    Q_reg <= Q_next;
end

endmodule