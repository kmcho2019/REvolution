module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;
wire Q_next = (j & ~k) ? 1'b1 :
              (~j & k) ? 1'b0 :
              (j & k) ? ~Q_reg : Q_reg;

always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule