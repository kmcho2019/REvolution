module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

wire Q_next;
assign Q_next = (j & ~k) | (~j & ~k & Q) | (j & k & ~Q);

reg Q_reg;
always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule